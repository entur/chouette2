class AddForeignKeyToDestinationDisplayVias < ActiveRecord::Migration[5.2]
  def up

    execute <<-SQL
      DELETE FROM destination_display_via where destination_display_via.destination_display_id NOT IN (select destination_displays.id  from destination_displays);
      DELETE FROM destination_display_via where destination_display_via.via_id NOT IN (select destination_displays.id  from destination_displays);
    SQL

    add_foreign_key "destination_display_via", "destination_displays", column: "destination_display_id", name: "destination_display_via_destination_display"
    add_foreign_key "destination_display_via", "destination_displays", column: "via_id", name: "destination_display_via_via"

  end

  def down
    remove_foreign_key "destination_display_via", "destination_displays", column: "destination_display_id"
    remove_foreign_key "destination_display_via", "destination_displays", column: "via_id"
  end
end
