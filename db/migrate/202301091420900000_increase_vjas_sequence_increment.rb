class IncreaseVjasSequenceIncrement < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
       ALTER SEQUENCE vehicle_journey_at_stops_id_seq increment by 1000;
    SQL
  end

  def down
    execute <<-SQL
       ALTER SEQUENCE vehicle_journey_at_stops_id_seq increment by 100;
    SQL
  end
end
