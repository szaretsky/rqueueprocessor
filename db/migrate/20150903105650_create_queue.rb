class CreateQueue < ActiveRecord::Migration
  def change
    create_table(   :queues, id: false) do |t|
	t.integer   :queueid, null: false
	t.text      :event
	t.integer   :status, default: 1
	t.timestamp :ts
    end
    reversible do |dir|
      dir.up do
        execute <<-SQL
          ALTER TABLE queues ALTER COLUMN ts SET default now();
          ALTER TABLE queues ADD COLUMN eventid SERIAL PRIMARY KEY;
        SQL
      end
      dir.down do
        execute <<-SQL
          ALTER TABLE queues DROP COLUMN eventid;
        SQL
      end
    end

  end
end
