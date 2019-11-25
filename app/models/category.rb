class Category < ApplicationRecord

	#ManytoMany Book_Category
	has_many :bookcategories, dependent: :destroy
	has_many :books, through: :bookcategories	, source: :book
	accepts_nested_attributes_for :bookcategories
	#Validate
	validates :name, presence: true, length: { maximum: 50 }
	
	def self.to_csv(option ={})
		CSV.generate(option) do |csv|
			csv << column_names
			all.each do |category|
				csv << category.attributes.values_at(*column_names)
			end
		end
	end
end
