require 'sqlite3'

def db
  database = SQLite3::Database.new("db/store.db")
  database.results_as_hash = true
  return database
end

class Scout
 
  attr_reader :id, :name, :contact, :status, :carid

  def initialize(data)
    p "new scout"
    p data
    @id = data["id"]
    @name = data["name"]
    @contact = data["contact"]
    @status = data["status"]
    @car_id = data["car_id"]
  end

  def self.create(name, contact)
    db.execute("INSERT INTO scouts (name, contact, status) VALUES (?, ?, 0)", name, contact)
  end

  def self.move(id, car_id)
    db.execute("UPDATE scouts SET car_id = ? WHERE id = ?", car_id, id)
  end

end

class UserError < StandardError

end

class User
  attr_reader :id, :name, :phone, :role, :groups

  def initialize(data)
    @id = data["id"]
    @name = data["name"]
    @phone = data["phone"]
    @role = data["role"]
    res = db.execute("SELECT groups.name FROM groups INNER JOIN group_rel ON groups.id = group_rel.group_id WHERE group_rel.user_id = ?", @id)
    @groups = res.map{|data| data["name"]}

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
  attr_reader :id, :scouts

  def initialize(data)
    @id = data["id"]
    res = db.execute("SELECT * FROM scouts WHERE car_id = ?", @id)
    @scouts = res.map{|data| Scout.new(data)}
  end

  def self.get_by_id(id)
    res = db.execute("SELECT * FROM cars WHERE id = ?", id)
    if res.length
      return Car.new(res.first)
    end

    return nil
  
  end

  def self.get_all(filters=nil)
    if filters != nil
      res = db.execute("SELECT cars.id as id, cars.status as status 
        FROM ((groups        
          INNER JOIN group_rel ON groups.id = group_rel.group_id) 
          INNER JOIN cars ON group_rel.car_id = cars.id) 
        WHERE groups.name = " + filters.map{|x| "?"}.join(" OR groups.name = "), *filters)
    else
      res = db.execute("SELECT * from cars")
    end

    return res.map{|data| Car.new(data)}

  end

end
