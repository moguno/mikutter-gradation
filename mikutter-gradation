# -*- coding: utf-8 -*-

Plugin.create :gradation do
  UserConfig[:gradation_shade] ||= 70

  class Gdk::MiraclePainter
    alias_method :render_background_old, :render_background

    def render_background(context)
      context.save{
        rgb = get_backgroundcolor
        rgb2 = rgb.map { |a| a * (UserConfig[:gradation_shade] / 100.0) }
        pattern = Cairo::LinearPattern.new(0, 0, width, height)
        pattern.add_color_stop_rgb(0.0, rgb[0], rgb[1], rgb[2])
        pattern.add_color_stop_rgb(1.0, rgb2[0], rgb2[1], rgb2[2])
        context.set_source(pattern)
        context.rectangle(0,0,width,height)
        context.fill
      }
    end
  end

  settings "グラデーション" do
    adjustment("濃さ(%)", :gradation_shade, 0, 100)
  end

end
