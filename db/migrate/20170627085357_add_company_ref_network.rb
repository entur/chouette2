class AddCompanyRefNetwork < ActiveRecord::Migration
  def change
    add_column :networks, :company_id, :int
    add_foreign_key :networks, :companies, on_delete: :nullify, name: 'network_company_fkey'
  end
end
