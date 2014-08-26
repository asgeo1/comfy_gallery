# require 'comfy_gallery/configuration'

module Gallery::GalleryHelper
	#
	# Renders a gallery of images using the gallery's layout or the default layout
	#
	def render_gallery (gallery_id_or_name)
		id = gallery_id_or_name.to_i
		if id != 0
			gallery = Gallery::Gallery.find(id)
		else
			gallery = Gallery::Gallery.where("identifier = '#{gallery_id_or_name}'").first
		end
		
		return if gallery.nil?

		id = gallery.layout || ComfyGallery.config.default_layout
		if id.present?
			# Find the layout for this id
			ComfyGallery.config.layouts.each do |layout|
				if layout.id == id
					# Allow layout to get fancy and do their own rendering
					if layout.respond_to? :render
						return layout.render gallery
					else
						# Just display a partial
						return render partial: "gallery_layouts/#{layout.partial}", locals: {gallery: gallery}
					end
				end
			end
		end
	end

	#
	# Displays a gallery photo, ensuring we use an S3 expiring src link
	# style - :thumb, :full, :admin_thumb, :admin_full
	#
	def gallery_image_tag(photo, style, options={})
		image_tag(photo.image.expiring_url(ComfyGallery.config.s3_timeout,style), options)
	end

end