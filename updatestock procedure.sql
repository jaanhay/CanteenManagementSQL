use canteen;
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
