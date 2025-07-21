use canteen;
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
    PRIMARY KEY (order_id, item_id),
	FOREIGN KEY (order_id) REFERENCES Orders(order_id)
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

timelog timestamp );
alter table log
add constraint transaction_type CHECK (transaction_type='IN'or transaction_type='OUT');

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
    
INSERT INTO Orders
values(1,'2020-07-01');
Insert into Orders
values(2,'2022-09-06');








