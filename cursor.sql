show databases;
use company1;
show tables;
delimiter $$
create procedure cursorpointer()
begin
	declare done int default 0;
    declare vno int;
    declare vname varchar(10);
    declare C1 cursor for select EMPNO,ENAME 
		from empp;
	declare continue handler for not found 
		set done = 1;
	open C1;
    repeat
		fetch C1 into vno,vname;
        select vno,vname;
	until done = 1
    end repeat;
END $$
	
CALL cursorpointer();
