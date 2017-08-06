class HomesController < ApplicationController
	def index
		@items = Item.all.order('priority ASC')
		@rawmaterials = RawMaterial.all
		@itemdetails = ItemDetail.all		
	end
end
