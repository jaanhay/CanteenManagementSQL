use canteen_system;
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
CREATE TABLE Orders ( 
	order_id INT PRIMARY KEY AUTO_INCREMENT,
    order_date date
);
CREATE TABLE Item (
	order_id INT, 
    item_id INT,
    item_name TEXT,
    item_quantity INT,
    PRIMARY KEY (order_id)
);
create table placeorder( new_order_id int, 
item_id int, item_name varchar(30), item_qty int, order_date date);
select * from placeorder;
alter table placeorder
add remaining decimal(10,2);
ALTER TABLE placeorder
ADD PRIMARY KEY auto_increment (new_order_id) ;

create table log( id int primary key auto_increment,
old_stock_value int,
new_stock_value int,
transaction_type VARCHAR(3) CHECK (transaction_type='IN'or transaction_type='OUT');
timelog timestamp );
alter table log
add column 

use canteen_system;
select * from Orders;
INSERT INTO Orders
values(1,'2020-07-01');
Insert into Orders
values(2,'2022-09-06');

delimiter $$ 
drop procedure if exists updatestock;
create procedure updatestock(oID INT)
     BEGIN
              declare done int default 0;
              declare f_id int;
              declare f_item_quantity int;
              declare f_qty int;
              declare C1 cursor for select ingredient_id,item_quantity,quantity
                                              from (select a.order_id,a.item_id,a.item_name,a.item_quantity,b.recipe_id,b.ingredient_id,b.quantity,c.Name,c.IngredientID,c.CurrentStock
     from Item a
     inner join recipe_ingredients b
     on a.item_id=b.recipe_id
     inner join Ingredients c
     on b.ingredient_id=c.IngredientID
     where a.order_id=oID)AS derived_table_alias;
              declare continue handler for not found set done =1;
     open C1;
     repeat
		fetch C1 into f_id,f_item_quantity,f_qty;
        if not done then
		update Ingredients
		SET CurrentStock = CurrentStock - f_item_quantity*f_qty
		where IngredientID=f_id and (CurrentStock - (f_item_quantity*f_qty))>0;
        end if;
     until done
     end repeat;
     close C1;
end $$
delimiter ;


delimiter $$
drop procedure if exists check_reorder_and_place_order;
create procedure check_reorder_and_place_order()
begin
declare done int default 0;
    declare ingredient_id int;
    declare stock decimal(10, 2);
    declare reorder_level decimal(10, 2);

    declare reorder_cursor cursor for
        select IngredientId, CurrentStock, ReorderLevel
        from Ingredients
        where CurrentStock < Reorderlevel;
        
declare continue handler for not found set done=1;
    open reorder_cursor;
    repeat
        fetch reorder_cursor into ingredient_id, stock, reorder_level;
	
         insert into placeorder (item_id, item_name, item_qty, order_date,remaining)
         values (ingredient_id, (select name from ingredients where ingredientid = ingredient_id),100, current_date,stock);
    until done
    end repeat;
close reorder_cursor;
end$$

delimiter ;

delimiter $$
create trigger updatingstock
after insert on item
for each row
begin
	
	call updatestock(new.order_id);
    call check_reorder_and_place_order;
end $$

delimiter ;


drop trigger if exists forlog;
delimiter &
create trigger forlog
after update on Ingredients
for each row
	insert into log
    set old_stock_value=old.CurrentStock,
	new_stock_value=new.CurrentStock,
    transaction_type="OUT",
    timelog = now();
    
end &
delimiter ;
 select * from Item;
 select * from ingredients;
 select * from recipe_ingredients;
 select * from recipes;

select * from Orders;
select * from item;
alter table Item 
modify item_id INT AUTO_INCREMENT;
desc item;
use canteen_system;
desc item;
-- Show foreign keys for a specific table
SHOW CREATE table item;
alter table item
drop foreign key item_ibfk_1;
alter table item
drop primary key;
alter table item
add foreign key(order_id) references Orders(order_id); 

insert into Item(order_id,item_id,item_name,item_quantity) 
values
(2,2,'Pancakes',1);
select * from orders;
select * from log;
select * from recipe_ingredients;
select * from ingredients;
insert into Item(order_id,item_id,item_name,item_quantity) 
values
(2,2,'Pancakes',1);
use canteen;
select * from ingredients;
select * from item;
