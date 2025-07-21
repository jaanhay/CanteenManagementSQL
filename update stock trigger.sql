use canteen;
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
    timelog = now(),
    updated_ingredient=old.Name;
end &
delimiter ;