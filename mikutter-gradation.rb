# -*- coding: utf-8 -*-

Plugin.create :gradation do
  UserConfig[:gradation_shade] ||= 80
  UserConfig[:gradation_selected] ||= true
  UserConfig[:gradation_system] ||= true
  UserConfig[:gradation_from_me] ||= true
  UserConfig[:gradation_to_me] ||= true
  UserConfig[:gradation_tweet] ||= false
 
  class Gdk::MiraclePainter
    def gradation?
      [
        UserConfig[:gradation_selected] && selected,
        UserConfig[:gradation_system] && to_message.system?,
        UserConfig[:gradation_from_me] && to_message.from_me?,
        UserConfig[:gradation_to_me] && to_message.to_me?,
        UserConfig[:gradation_tweet],
      ].any? { |a| a }
    end

    alias_method :render_background_org, :render_background

    def render_background(context)
      if gradation?
        context.save{
          rgb = get_backgroundcolor
          rgb2 = rgb.map { |a| a * (UserConfig[:gradation_shade] / 100.0) }
          pattern = Cairo::LinearPattern.new(0, 0, width, height)
          pattern.add_color_stop_rgb(0.0, *rgb)
          pattern.add_color_stop_rgb(0.3, *rgb)
          pattern.add_color_stop_rgb(1.0, *rgb2)
          context.set_source(pattern)
          context.rectangle(0, 0, width, height)
          context.fill
        }
      else
        render_background_org(context)
      end
    end
  end

  settings "グラデーション" do
    adjustment("濃さ(%)", :gradation_shade, 0, 100)
    boolean("つぶやき", :gradation_tweet)
    boolean("自分宛", :gradation_to_me)
    boolean("自分のつぶやき", :gradation_from_me)
    boolean("システムメッセージ", :gradation_system)
    boolean("選択中", :gradation_selected)
  end

end
