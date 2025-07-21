use canteen;


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