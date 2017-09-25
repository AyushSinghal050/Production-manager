class HomesController < ApplicationController
	
	def index

		@items = Item.all.order('priority ASC')
		


	end
	def today
		@items = Item.all.order('priority ASC')
		@rawmaterials = RawMaterial.all
		@itemdetails = ItemDetail.all	
	end

	def update
		i = 0
		xlsx = Roo::Spreadsheet.open('/home/ayush/Desktop/SHORTAGE AUGUST 2ND WEEK  06.08.17.xlsx')

		while xlsx.sheet('SHORTAGE').cell(i,4) != "PROD_DESC"
			i = i + 1
		end
		start = i+1
		i = start

		while xlsx.sheet('SHORTAGE').cell(i,4)
			@item = Item.find_by_name(xlsx.sheet('SHORTAGE').cell(i,4))
			unless @item
				@item = Item.new
				@item.name = xlsx.sheet('SHORTAGE').cell(i,4)
				@item.priority = @item.id 
				@item.Demand = 50
				@item.save				
			end
			@raw = RawMaterial.find_by_name(xlsx.sheet('SHORTAGE').cell(i,6))
			unless @raw
				@raw = RawMaterial.new
				@raw.name = xlsx.sheet('SHORTAGE').cell(i,6) 
				@raw.weightin = 'Kg'				
			end
			@raw.quantity = xlsx.sheet('SHORTAGE').cell(i,8)
			unless @raw.quantity
				@raw.quantity = 0				
			end
			@raw.save
			@detail = ItemDetail.find_by item_id: @item.id , rawMaterial_id: @raw.id
			
			unless @detail
				@detail = ItemDetail.new
				@detail.item_id = @item.id
				@detail.rawMaterial_id = @raw.id
				@detail.minweight = 100
				@detail.weightin = 'g'
				@detail.save	
			end
			i = i + 1
		end	

		production
		today_production

		return redirect_to '/'	
	end

	private
	def production
		@items = Item.where("Demand > ?",0).order('priority ASC')
		@rawmaterials = RawMaterial.all
		@itemdetails = ItemDetail.all

		@items.each do |item|
			max_production = -1
			@itemdetails.where(item_id: item.id).each do |itemdetail|
				quantity = @rawmaterials.find(itemdetail.rawMaterial_id).quantity
				if quantity < 0
					quantity = 0					
				end
				if @rawmaterials.find(itemdetail.rawMaterial_id).weightin == "Kg" && itemdetail.weightin == 'g'
					quantity = quantity * 1000
				end
				quantity_can_produce = quantity/itemdetail.minweight

				if quantity_can_produce > item.Demand 
					quantity_can_produce = item.Demand 			
				end

				if max_production == -1 || max_production > quantity_can_produce
					max_production = quantity_can_produce					
				end
			end
			item.MaxProduction = max_production
			item.save
		end
	end

	def today_production
		@items = Item.where("MaxProduction > ?",-1).order('priority ASC')
		@rawmaterials = RawMaterial.all
		@itemdetails = ItemDetail.all
		
		@items.each do |item|
			max_production = -1
			@itemdetails.where(item_id: item.id).each do |itemdetail|
				quantity = @rawmaterials.find(itemdetail.rawMaterial_id).quantity
				if quantity < 0
					quantity = 0					
				end
				if @rawmaterials.find(itemdetail.rawMaterial_id).weightin == "Kg" && itemdetail.weightin == 'g'
					quantity = quantity * 1000
				end
				quantity_can_produce = quantity/itemdetail.minweight

				if quantity_can_produce > item.Demand 
					quantity_can_produce = item.Demand 			
				end

				if max_production == -1 || max_production > quantity_can_produce
					max_production = quantity_can_produce					
				end
			end	
			item.today_production = max_production
			item.save
			@itemdetails.where(item_id: item.id).each do |itemdetail|
				raw = @rawmaterials.find(itemdetail.rawMaterial_id)
				
			
				if raw.weightin == "Kg" || raw.weightin == "kg"
					if itemdetail.weightin == "g"
						raw.quantity = raw.quantity - max_production*itemdetail.minweight/1000						
					end
					
				elsif raw.weightin == itemdetail.weightin
						raw.quantity = raw.quantity - max_production*itemdetail.minweight
				end
				raw.save
			end	
	
		end


	end
end

