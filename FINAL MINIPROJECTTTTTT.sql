create database canteen_mnm;
use canteen_mnm;
CREATE TABLE Ingredients (
    IngredientID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255) NOT NULL,
    Category VARCHAR(50),
    UnitOfMeasure VARCHAR(20) NOT NULL,
    CurrentStock DECIMAL(10, 2) NOT NULL,
    ReorderLevel DECIMAL(10, 2) NOT NULL
);
CREATE TABLE recipes (
    recipe_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    serving_size INT,
    instructions TEXT
);

CREATE TABLE recipe_ingredients (
    recipe_id INT,
    ingredient_id INT,
    quantity DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (recipe_id, ingredient_id),
    FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id),
    FOREIGN KEY (ingredient_id) REFERENCES Ingredients(IngredientId)
);

CREATE TABLE Item (
	order_id INT, 
    item_id INT,
    item_name TEXT,
    item_quantity INT,
    PRIMARY KEY (order_id)
);

create table log( id int primary key auto_increment,
old_stock_value int,
new_stock_value int,
transaction_type VARCHAR(3) CHECK (transaction_type='IN'or transaction_type='OUT'),
timelog timestamp );

INSERT INTO Ingredients (Name, Category, UnitOfMeasure, CurrentStock, ReorderLevel)
VALUES
    ('Flour', 'Baking', 'kg', 50.00, 10.00),
    ('Sugar', 'Baking', 'kg', 30.50, 5.00),
    ('Eggs', 'Dairy', 'unit', 100.00, 20.00),
    ('Milk', 'Dairy', 'L', 20.00, 5.00),
    ('Chocolate Chips', 'Baking', 'g', 200.00, 50.00);


INSERT INTO recipes (name, serving_size, instructions)
VALUES
    ('Chocolate Chip Cookies', 12, '1. Preheat the oven to 350°F. ...'),
    ('Pancakes', 4, '1. In a bowl, mix flour, sugar, and baking powder. ...'),
    ('Scrambled Eggs', 2, '1. Crack the eggs into a bowl. ...');



INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity)
VALUES
    (1, 1, 300.00),
    (1, 2, 150.00),
    (1, 3, 2.00),
    (1, 4, 100.00),
    (1, 5, 150.00),
    (2, 1, 200.00),
    (2, 2, 100.00),
    (2, 3, 3.00),
    (3, 3, 4.00);

ALTER TABLE Item
DROP PRIMARY KEY;

-- Step 2: Modify column and set it as primary key with auto-increment
ALTER TABLE Item
MODIFY COLUMN order_id INT AUTO_INCREMENT PRIMARY KEY;

INSERT INTO Item (item_id, item_name, item_quantity) VALUES
    ( 1, 'Chocolate Chip Cookies', 5),
    ( 2, 'Pancakes', 3),
    ( 3, 'Scrambled Eggs', 2),
    ( 1, 'Chocolate Chip Cookies', 4),
    (2, 'Pancakes', 1),
    ( 3, 'Scrambled Eggs', 7),
    ( 1, 'Chocolate Chip Cookies', 3);

DELETE FROM Item
WHERE order_id = 1;

DELETE FROM Item
WHERE order_id = 2;
DELETE FROM Item
WHERE order_id = 3;
DELETE FROM Item
WHERE order_id = 4;
DELETE FROM Item
WHERE order_id = 5;
DELETE FROM Item
WHERE order_id = 6;
DELETE FROM Item
WHERE order_id = 7;

drop procedure if exists updatestock;
delimiter $$ 
create procedure updatestock(oID INT)
     BEGIN
              declare done int default 0;
              declare f_id int;
              declare f_item_quantity int;
              declare f_qty int;
              declare C1 cursor for select ingredient_id,item_quantity,quantity
                                              from (select a.order_id,a.item_id,a.item_name,
                                              a.item_quantity,b.recipe_id,b.ingredient_id,b.quantity,
                                              c.Name,c.IngredientID,c.CurrentStock
											from Item a
											inner join recipe_ingredients b
											on a.item_id=b.recipe_id
											inner join Ingredients c
											on b.ingredient_id=c.IngredientID
											where a.order_id=oID)as something;
              declare continue handler for not found set done =1;
	open C1;
     repeat
		fetch C1 into f_id,f_item_quantity,f_qty;
		update Ingredients
		set CurrentStock=CurrentStock - f_item_quantity*f_qty
		where IngredientID=f_id AND f_item_quantity*f_qty>0;
     until done
     end repeat;
     close C1;
end $$



delimiter $$


DELIMITER $$
CREATE TRIGGER updatingstock
AFTER INSERT ON Item
FOR EACH ROW
BEGIN
    
    CALL updatestock(NEW.order_id);
END $$
DELIMITER ;

select * from recipes;
select * from Item;
insert into Item(item_id,item_name,item_quantity) values (3,'Scrambled Eggs',1);
select * from ingredients;
select * from recipe_ingredients;

use canteen_mnm;
drop trigger if exists logging_stock;
delimiter $$
create trigger logging_stock
before update on Ingredients
for each row
begin
      insert into log
      set old_stock_value=old.CurrentStock,
      new_stock_value=new.CurrentStock,
      transaction_type='OUT',
      timelog=now();
      select * from log;
end$$
delimiter ;
alter table log
add column item_name varchar(255);
insert into Item(item_id,item_name,item_quantity) values (3,'Scrambled Eggs',2);

DELIMITER $$
CREATE TRIGGER logging_stock
BEFORE UPDATE ON Ingredients
FOR EACH ROW
BEGIN
    DECLARE old_stock_value INT;
    DECLARE new_stock_value INT;
    DECLARE item_name VARCHAR(255); 

    -- Set variables
    SET old_stock_value = OLD.CurrentStock;
    SET new_stock_value = NEW.CurrentStock;
    SET item_name = NEW.Name; 

    -- Insert into log
    INSERT INTO log (old_stock_value, new_stock_value, item_name, transaction_type, timelog)
    VALUES (old_stock_value, new_stock_value, item_name, 'OUT', NOW());
END $$
DELIMITER ;
select * from log;
update log
set item_name='Eggs'
where id=1;
update log
set item_name='Eggs'
where id=2;
create table place_order(
id int primary key auto_increment,
OrderItem varchar(255)
);
drop trigger afterupdate;
drop procedure if exists check_level;
delimiter $$

create procedure check_level(in stock int)
begin 
		declare R int;
        declare OrderItem varchar(255);
        select Name into OrderItem from ingredients where CurrentStock=stock;
        select ReorderLevel into R from Ingredients where CurrentStock=stock;
		if stock<R
        then 
			insert into place_order(OrderItem) values(OrderItem);
        end if;
END$$
delimiter ;
delimiter $$
create trigger afterupdate
after update on Ingredients
for each row
begin
	call check_level(new.CurrentStock);
end$$
delimiter ;
select * from recipes;
show triggers;
select * from item;
use canteen_mnm;
select * from log;
desc place_order;