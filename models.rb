require 'sqlite3'

def db
  database = SQLite3::Database.new("db/store.db")
  database.results_as_hash = true
  return database
end

class Scout
 
  attr_reader :id, :name, :contact, :status, :carid

  def initialize(data)
    @id = data["id"]
    @name = data["name"]
    @contact = data["contact"]
    @status = data["status"]
    @carid = data["carid"]
  end

  def self.create(name, contact)
    db.execute("INSERT INTO scouts (name, contact, status) VALUES (?, ?, 0)", name, contact)
  end

  def self.get_all(user_id, filter="all")
    return db.execute("SELECT * FROM todos WHERE user_id = ?", user_id).map {|data| Todo.new(data)}.select{|t| t.status==filter || filter=="all"}.sort_by{|t| t.status != nil ? t.status : ""}
  end

  def self.get_by_id(id)
    t = db.execute("SELECT * FROM todos WHERE id = ?", id)
    if t.length
      return new(t.first)
    else
      return nil
    end
  end

  def self.delete(id)
    db.execute("DELETE FROM todos WHERE id = ?", id)
  end

  def delete
    db.execute("DELETE FROM todos WHERE id = ?", @id)
  end

  def self.delete_all(user_id)
    db.execute("DELETE FROM todos WHERE user_id = ?", user_id)
  end

  def self.edit(id, new_content)
    db.execute("UPDATE todos SET content = ? WHERE id = ?", new_content, id)
  end

  def edit(new_content)
    db.execute("UPDATE todos SET content = ? WHERE id = ?", new_content, @id)
  end

  def self.set_status(id, status)
    db.execute("UPDATE todos SET status = ? WHERE id = ?", status, id)
  end

  def self.clear_completed(user_id)
    db.execute("DELETE FROM todos WHERE user_id = ? AND status = 'done' ", user_id)
  end

  def change_user(new_user_id)
    db.execute("UPDATE todos SET user_id = ? WHERE id = ?", new_user_id, @id)
  end

end

class UserError < StandardError

end

class User
  attr_reader :id, :name, :phone, :role

  def initialize(data)
    @id = data["id"]
    @name = data["name"]
    @phone = data["phone"]
    @role = data["role"]
  end

  def self.create_parent(name, phone)
    temp_db = db
    temp_db.execute("INSERT INTO users (name, phone, role) VALUES (?,?, 'parent')", name, phone)

    return temp_db.last_insert_row_id
  end

  def self.create_leader(name, phone)
    temp_db = db
    temp_db.execute("INSERT INTO users (name, phone, role) VALUES (?,?, 'leader')", name, phone)

    return temp_db.last_insert_row_id
  end

  def self.find_by_id(id)
    res = db.execute("SELECT * FROM users WHERE id = ?", id)
    if res.length
      return User.new(res.first)
    end

    return nil

  end

  def self.find_by_phone(phone)
    res = db.execute("SELECT * FROM users WHERE phone = ?", phone)

    if res.length > 0
      return User.new(res.first)
    end

    return nil
  end

end

class Car

  def initialize(data)
    @id = data["id"]
  end

end
