create table log( id int primary key auto_increment,

old_stock_value int,
new_stock_value int,

timelog timestamp );
alter table log
add constraint transaction_type CHECK (transaction_type='IN'or transaction_type='OUT');


delimiter //
desc log;
