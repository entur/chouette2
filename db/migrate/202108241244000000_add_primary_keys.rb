class AddPrimaryKeys < ActiveRecord::Migration
  def up
   execute "ALTER TABLE booking_arrangements_booking_methods ADD PRIMARY KEY (booking_arrangement_id, booking_method);"
    execute "ALTER TABLE booking_arrangements_buy_when ADD PRIMARY KEY (booking_arrangement_id, buy_when);"
    execute "ALTER TABLE dated_service_journey_refs ADD PRIMARY KEY (original_dsj_id, derived_dsj_id);"
    execute "ALTER TABLE destination_display_via ADD PRIMARY KEY (destination_display_id, via_id);"
    execute "ALTER TABLE facilities_features ADD PRIMARY KEY (facility_id, choice_code);"
    execute "ALTER TABLE footnotes_journey_patterns ADD PRIMARY KEY (footnote_id, journey_pattern_id);"
    execute "ALTER TABLE footnotes_lines ADD PRIMARY KEY (footnote_id, line_id);"
    #execute "ALTER TABLE footnotes_stop_points ADD PRIMARY KEY (footnote_id, stop_point_id);"
    #execute "ALTER TABLE footnotes_vehicle_journey_at_stops ADD PRIMARY KEY (footnote_id, vehicle_journey_at_stop_id);"
    execute "ALTER TABLE footnotes_vehicle_journeys ADD PRIMARY KEY (footnote_id, vehicle_journey_id);"
    execute "ALTER TABLE group_of_lines_lines ADD PRIMARY KEY (group_of_line_id, line_id);"
    execute "ALTER TABLE journey_patterns_stop_points ADD PRIMARY KEY (journey_pattern_id, stop_point_id);"
    execute "ALTER TABLE lines_key_values ADD PRIMARY KEY (line_id, key, value);"
    execute "ALTER TABLE routing_constraints_lines ADD PRIMARY KEY (line_id, stop_area_objectid_key);"
    execute "ALTER TABLE stop_areas_stop_areas ADD PRIMARY KEY (parent_id, child_id);"
    execute "ALTER TABLE time_tables_vehicle_journeys ADD PRIMARY KEY (time_table_id, vehicle_journey_id);"
    execute "ALTER TABLE vehicle_journeys_key_values ADD PRIMARY KEY (vehicle_journey_id, key, value);"



    # Remove redundant indexes
    remove_index :dated_service_journey_refs, name: "dated_service_journey_refs_original_dsj_id_derived_dsj_id_key" if index_name_exists?(:dated_service_journey_refs, :dated_service_journey_refs_original_dsj_id_derived_dsj_id_key, quoted_true)
  end

  def down
     execute "ALTER TABLE booking_arrangements_booking_methods DROP CONSTRAINT booking_arrangements_booking_methods_pkey;"
    execute "ALTER TABLE booking_arrangements_buy_when DROP CONSTRAINT booking_arrangements_buy_when_pkey;"
    execute "ALTER TABLE dated_service_journey_refs DROP CONSTRAINT dated_service_journey_refs_pkey;"
    execute "ALTER TABLE destination_display_via DROP CONSTRAINT destination_display_via_pkey;"
    execute "ALTER TABLE facilities_features DROP CONSTRAINT facilities_features_pkey;"
    execute "ALTER TABLE footnotes_journey_patterns DROP CONSTRAINT footnotes_journey_patterns_pkey;"
    execute "ALTER TABLE footnotes_lines DROP CONSTRAINT footnotes_lines_pkey;"
    #execute "ALTER TABLE footnotes_stop_points DROP CONSTRAINT footnotes_stop_points_pkey;"
    #execute "ALTER TABLE footnotes_vehicle_journey_at_stops DROP CONSTRAINT footnotes_vehicle_journey_at_stops_pkey;"
    execute "ALTER TABLE footnotes_vehicle_journeys DROP CONSTRAINT footnotes_vehicle_journeys_pkey;"
    execute "ALTER TABLE group_of_lines_lines DROP CONSTRAINT group_of_lines_lines_pkey;"
    execute "ALTER TABLE journey_patterns_stop_points DROP CONSTRAINT journey_patterns_stop_points_pkey;"
    execute "ALTER TABLE lines_key_values DROP CONSTRAINT lines_key_values_pkey;"
    execute "ALTER TABLE routing_constraints_lines DROP CONSTRAINT routing_constraints_lines_pkey;"
    execute "ALTER TABLE stop_areas_stop_areas DROP CONSTRAINT stop_areas_stop_areas_pkey;"
    execute "ALTER TABLE time_tables_vehicle_journeys DROP CONSTRAINT time_tables_vehicle_journeys_pkey;"
    execute "ALTER TABLE vehicle_journeys_key_values DROP CONSTRAINT vehicle_journeys_key_values_pkey;"

    # Add back redundant indexes
    add_index "dated_service_journey_refs", ["original_dsj_id", "derived_dsj_id"], name: "dated_service_journey_refs_original_dsj_id_derived_dsj_id_key", unique: true, using: :btree unless index_name_exists?(:dated_service_journey_refs, :dated_service_journey_refs_original_dsj_id_derived_dsj_id_key, quoted_true)
    end
end

__END__

schema_migrations




