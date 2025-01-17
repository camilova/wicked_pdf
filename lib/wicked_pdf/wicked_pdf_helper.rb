class WickedPdf
  module WickedPdfHelper
    def self.root_path
      String === Rails.root ? Pathname.new(Rails.root) : Rails.root
    end

    def self.add_extension(filename, extension)
      filename.to_s.split('.').include?(extension) ? filename : "#{filename}.#{extension}"
    end

    def wicked_pdf_stylesheet_link_tag(*sources)
      css_dir = WickedPdfHelper.root_path.join('public', 'stylesheets')
      css_text = sources.collect do |source|
        source = WickedPdfHelper.add_extension(source, 'css')
        "<style type='text/css'>#{File.read(css_dir.join(source))}</style>"
      end.join("\n")
      css_text.respond_to?(:html_safe) ? css_text.html_safe : css_text
    end

    def wicked_pdf_image_tag(img, options = {})
      path = WickedPdfHelper.root_path.join('public', 'images', img)
      image_tag URI.join('file:', '', path).to_s, options
    end

    def wicked_pdf_javascript_src_tag(jsfile, options = {})
      jsfile = WickedPdfHelper.add_extension(jsfile, 'js')
      type = ::Mime.respond_to?(:[]) ? ::Mime[:js] : ::Mime::JS # ::Mime[:js] cannot be used in Rails 2.3.
      path = WickedPdfHelper.root_path.join('public', 'javascripts', jsfile)
      src = URI.join('file:', '', path).to_s
      content_tag('script', '', { 'type' => type, 'src' => path_to_javascript(src) }.merge(options))
    end

    def wicked_pdf_javascript_include_tag(*sources)
      js_text = sources.collect { |source| wicked_pdf_javascript_src_tag(source, {}) }.join("\n")
      js_text.respond_to?(:html_safe) ? js_text.html_safe : js_text
    end
  end
end
