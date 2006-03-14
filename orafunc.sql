SET search_path = public;

CREATE OR REPLACE FUNCTION trunc(value date, fmt text)
RETURNS date
AS '$libdir/orafunc','ora_date_trunc'
LANGUAGE 'C' IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION round(value date, fmt text)
RETURNS date
AS '$libdir/orafunc','ora_date_round'
LANGUAGE 'C' IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION next_day(value date, weekday text) 
RETURNS date
AS '$libdir/orafunc'
LANGUAGE 'C' IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION last_day(value date) 
RETURNS date
AS '$libdir/orafunc'
LANGUAGE 'C' IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION months_between(date1 date, date2 date) 
RETURNS float8
AS '$libdir/orafunc'
LANGUAGE 'C' IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION add_months(day date, value int) 
RETURNS date
AS '$libdir/orafunc'
LANGUAGE 'C' IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION trunc(value timestamp with time zone, fmt text) 
RETURNS timestamp with time zone
AS '$libdir/orafunc', 'ora_timestamptz_trunc'
LANGUAGE 'C' IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION round(value timestamp with time zone, fmt text) 
RETURNS timestamp with time zone
AS '$libdir/orafunc','ora_timestamptz_round'
LANGUAGE 'C' IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION round(value timestamp with time zone)
RETURNS timestamp with time zone
AS $$ SELECT round($1, 'DDD'); $$
LANGUAGE 'SQL' IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION round(value date)
RETURNS date 
AS $$ SELECT $1; $$
LANGUAGE 'SQL' IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION trunc(value timestamp with time zone)
RETURNS timestamp with time zone
AS $$ SELECT trunc($1, 'DDD'); $$
LANGUAGE 'SQL' IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION trunc(value date)
RETURNS date 
AS $$ SELECT $1; $$
LANGUAGE 'SQL' IMMUTABLE STRICT;

DROP TABLE dual CASCADE;
CREATE TABLE dual(dummy varchar(1));
INSERT INTO dual(dummy) VALUES('X');
REVOKE ALL ON dual FROM PUBLIC;
GRANT SELECT, REFERENCES ON dual TO PUBLIC;
VACUUM ANALYZE dual;

CREATE OR REPLACE FUNCTION protect_table_fx() 
RETURNS TRIGGER 
AS '$libdir/orafunc','ora_protect_table_fx'
LANGUAGE C VOLATILE STRICT;

CREATE TRIGGER protect_dual BEFORE INSERT OR UPDATE OR DELETE
ON dual FOR EACH STATEMENT EXECUTE PROCEDURE protect_table_fx();

-- this packege is emulation of dbms_ouput Oracle packege
-- 

DROP SCHEMA dbms_output CASCADE;

CREATE SCHEMA dbms_output;

CREATE FUNCTION dbms_output.enable(IN buffer_size int4) 
RETURNS void 
AS '$libdir/orafunc','dbms_output_enable' 
LANGUAGE C VOLATILE STRICT;
    
CREATE FUNCTION dbms_output.enable()
RETURNS void 
AS '$libdir/orafunc','dbms_output_enable_default' 
LANGUAGE C VOLATILE STRICT;
    
CREATE FUNCTION dbms_output.disable()
RETURNS void
AS '$libdir/orafunc','dbms_output_disable' 
LANGUAGE C VOLATILE STRICT; 

CREATE FUNCTION dbms_output.serveroutput(IN bool)
RETURNS void
AS '$libdir/orafunc','dbms_output_serveroutput' 
LANGUAGE C VOLATILE STRICT;
    
CREATE FUNCTION dbms_output.put(IN a text)
RETURNS void
AS '$libdir/orafunc','dbms_output_put' 
LANGUAGE C VOLATILE STRICT;

CREATE FUNCTION dbms_output.put_line(IN a text)
RETURNS void
AS '$libdir/orafunc','dbms_output_put_line' 
LANGUAGE C VOLATILE STRICT;

CREATE FUNCTION dbms_output.new_line()
RETURNS void
AS '$libdir/orafunc','dbms_output_new_line' 
LANGUAGE C VOLATILE STRICT;

CREATE FUNCTION dbms_output.get_line(OUT line text, OUT status int4) 
AS '$libdir/orafunc','dbms_output_get_line' 
LANGUAGE C VOLATILE STRICT;
    
CREATE FUNCTION dbms_output.get_lines(OUT lines text[], INOUT numlines int4)
AS '$libdir/orafunc','dbms_output_get_lines' 
LANGUAGE C VOLATILE STRICT;

-- others functions

CREATE OR REPLACE FUNCTION nvl(anyelement, anyelement) 
RETURNS anyelement
AS '$libdir/orafunc','ora_nvl' 
LANGUAGE C IMMUTABLE;

CREATE OR REPLACE FUNCTION nvl2(anyelement, anyelement, anyelement) 
RETURNS anyelement
AS '$libdir/orafunc','ora_nvl2' 
LANGUAGE C IMMUTABLE;

CREATE OR REPLACE FUNCTION concat(text, text) 
RETURNS text 
AS '$libdir/orafunc','ora_concat' 
LANGUAGE C IMMUTABLE;

DROP SCHEMA dbms_pipe CASCADE;

CREATE SCHEMA dbms_pipe;

CREATE FUNCTION dbms_pipe.pack_message(text)
RETURNS void
AS '$libdir/orafunc','dbms_pipe_pack_message' 
LANGUAGE C VOLATILE STRICT;

CREATE FUNCTION dbms_pipe.unpack_message()
RETURNS text
AS '$libdir/orafunc','dbms_pipe_unpack_message' 
LANGUAGE C VOLATILE STRICT;

CREATE FUNCTION dbms_pipe.receive_message(cstring, int)
RETURNS int
AS '$libdir/orafunc','dbms_pipe_receive_message' 
LANGUAGE C VOLATILE STRICT;

CREATE FUNCTION dbms_pipe.send_message(cstring, int)
RETURNS int
AS '$libdir/orafunc','dbms_pipe_send_message' 
LANGUAGE C VOLATILE STRICT;

-- follow package PLVdate emulation

DROP SCHEMA plvdate CASCADE;

CREATE SCHEMA plvdate;

CREATE FUNCTION plvdate.add_bizdays(date, int)
RETURNS date
AS '$libdir/orafunc','plvdate_add_bizdays'
LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION plvdate.nearest_bizday(date)
RETURNS date
AS '$libdir/orafunc','plvdate_nearest_bizday'
LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION plvdate.next_bizday(date)
RETURNS date
AS '$libdir/orafunc','plvdate_next_bizday'
LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION plvdate.bizdays_between(date, date)
RETURNS int
AS '$libdir/orafunc','plvdate_bizdays_between'
LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION plvdate.prev_bizday(date)
RETURNS date
AS '$libdir/orafunc','plvdate_prev_bizday'
LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION plvdate.isbizday(date)
RETURNS bool
AS '$libdir/orafunc','plvdate_isbizday'
LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION plvdate.set_nonbizday(text)
RETURNS void
AS '$libdir/orafunc','plvdate_set_nonbizday_dow'
LANGUAGE C VOLATILE STRICT;

CREATE FUNCTION plvdate.unset_nonbizday(text)
RETURNS void
AS '$libdir/orafunc','plvdate_unset_nonbizday_dow'
LANGUAGE C VOLATILE STRICT;

CREATE FUNCTION plvdate.set_nonbizday(date, bool)
RETURNS void
AS '$libdir/orafunc','plvdate_set_nonbizday_day'
LANGUAGE C VOLATILE STRICT;

CREATE FUNCTION plvdate.unset_nonbizday(date, bool)
RETURNS void
AS '$libdir/orafunc','plvdate_unset_nonbizday_day'
LANGUAGE C VOLATILE STRICT;

CREATE FUNCTION plvdate.set_nonbizday(date)
RETURNS bool
AS $$SELECT plvdate.set_nonbizday($1, false); SELECT NULL::boolean;$$
LANGUAGE SQL VOLATILE STRICT;

CREATE FUNCTION plvdate.unset_nonbizday(date)
RETURNS bool
AS $$SELECT plvdate.unset_nonbizday($1, false); SELECT NULL::boolean;$$
LANGUAGE SQL VOLATILE STRICT;

CREATE FUNCTION plvdate.use_easter(bool)
RETURNS void
AS '$libdir/orafunc','plvdate_use_easter'
LANGUAGE C VOLATILE STRICT;

CREATE FUNCTION plvdate.use_easter()
RETURNS bool
AS $$SELECT plvdate.use_easter(true); SELECT NULL::boolean;$$
LANGUAGE SQL VOLATILE STRICT;

CREATE FUNCTION plvdate.unuse_easter()
RETURNS bool
AS $$SELECT plvdate.use_easter(false); SELECT NULL::boolean;$$
LANGUAGE SQL VOLATILE STRICT;

CREATE FUNCTION plvdate.using_easter()
RETURNS bool
AS '$libdir/orafunc','plvdate_using_easter'
LANGUAGE C VOLATILE STRICT;

CREATE FUNCTION plvdate.include_start(bool)
RETURNS void
AS '$libdir/orafunc','plvdate_include_start'
LANGUAGE C VOLATILE STRICT;

CREATE FUNCTION plvdate.include_start()
RETURNS bool
AS $$SELECT plvdate.include_start(true); SELECT NULL::boolean;$$
LANGUAGE SQL VOLATILE STRICT;

CREATE FUNCTION plvdate.noinclude_start()
RETURNS bool
AS $$SELECT plvdate.include_start(false); SELECT NULL::boolean;$$
LANGUAGE SQL VOLATILE STRICT;

CREATE FUNCTION plvdate.including_start()
RETURNS bool
AS '$libdir/orafunc','plvdate_including_start'
LANGUAGE C VOLATILE STRICT;

CREATE FUNCTION plvdate.version()
RETURNS cstring
AS '$libdir/orafunc','plvdate_version'
LANGUAGE C VOLATILE STRICT;

CREATE FUNCTION plvdate.default_holydays(text)
RETURNS void
AS '$libdir/orafunc','plvdate_default_holydays'
LANGUAGE C VOLATILE STRICT;

-- debug

CREATE FUNCTION sh_init()
RETURNS void
AS '$libdir/orafunc','__sinit'
LANGUAGE C VOLATILE STRICT;

CREATE FUNCTION sh_print()
RETURNS void
AS '$libdir/orafunc','__sprint'
LANGUAGE C VOLATILE STRICT;

CREATE FUNCTION sh_alloc(int)
RETURNS int
AS '$libdir/orafunc','__salloc'
LANGUAGE C VOLATILE STRICT;

CREATE FUNCTION sh_sfree(int)
RETURNS void
AS '$libdir/orafunc','__sfree'
LANGUAGE C VOLATILE STRICT;

CREATE FUNCTION sh_defrag()
RETURNS void
AS '$libdir/orafunc','__sdefrag'
LANGUAGE C VOLATILE STRICT;

-- PLVstr package

DROP SCHEMA plvstr CASCADE;

CREATE SCHEMA plvstr;

CREATE FUNCTION plvstr.normalize(str text)
RETURNS varchar
AS '$libdir/orafunc','plvstr_normalize'
LANGUAGE C STABLE STRICT;

CREATE FUNCTION plvstr.is_prefix(str text, prefix text, cs bool)
RETURNS bool
AS '$libdir/orafunc','plvstr_is_prefix_text'
LANGUAGE C STABLE STRICT;

CREATE FUNCTION plvstr.is_prefix(str text, prefix text)
RETURNS bool
AS $$ SELECT plvstr.is_prefix($1,$2,true);$$
LANGUAGE SQL STABLE STRICT;

CREATE FUNCTION plvstr.is_prefix(str int, prefix int)
RETURNS bool
AS '$libdir/orafunc','plvstr_is_prefix_int'
LANGUAGE C STABLE STRICT;

CREATE FUNCTION plvstr.is_prefix(str bigint, prefix bigint)
RETURNS bool
AS '$libdir/orafunc','plvstr_is_prefix_int64'
LANGUAGE C STABLE STRICT;

CREATE FUNCTION plvstr.substr(str text, start int, len int)
RETURNS varchar
AS '$libdir/orafunc','plvstr_substr3'
LANGUAGE C STABLE STRICT;

CREATE FUNCTION plvstr.substr(str text, start int)
RETURNS varchar
AS '$libdir/orafunc','plvstr_substr2'
LANGUAGE C STABLE STRICT;

CREATE FUNCTION plvstr.instr(str text, patt text, start int, nth int)
RETURNS int
AS '$libdir/orafunc','plvstr_instr4'
LANGUAGE C STABLE STRICT;

CREATE FUNCTION plvstr.instr(str text, patt text, start int)
RETURNS int
AS '$libdir/orafunc','plvstr_instr3'
LANGUAGE C STABLE STRICT;

CREATE FUNCTION plvstr.instr(str text, patt text)
RETURNS int
AS '$libdir/orafunc','plvstr_instr2'
LANGUAGE C STABLE STRICT;

CREATE FUNCTION plvstr.lpart(str text, div text, start int, nth int, all_if_notfound bool)
RETURNS text
AS '$libdir/orafunc','plvstr_lpart'
LANGUAGE C STABLE STRICT;

CREATE FUNCTION plvstr.lpart(str text, div text, start int, nth int)
RETURNS text
AS $$ SELECT plvstr.lpart($1,$2, $3, $4, false); $$
LANGUAGE SQL STABLE STRICT;

CREATE FUNCTION plvstr.lpart(str text, div text, start int)
RETURNS text
AS $$ SELECT plvstr.lpart($1,$2, $3, 1, false); $$
LANGUAGE SQL STABLE STRICT;

CREATE FUNCTION plvstr.lpart(str text, div text)
RETURNS text
AS $$ SELECT plvstr.lpart($1,$2, 1, 1, false); $$
LANGUAGE SQL STABLE STRICT;

CREATE FUNCTION plvstr.rpart(str text, div text, start int, nth int, all_if_notfound bool)
RETURNS text
AS '$libdir/orafunc','plvstr_rpart'
LANGUAGE C STABLE STRICT;

CREATE FUNCTION plvstr.rpart(str text, div text, start int, nth int)
RETURNS text
AS $$ SELECT plvstr.rpart($1,$2, $3, $4, false); $$
LANGUAGE SQL STABLE STRICT;

CREATE FUNCTION plvstr.rpart(str text, div text, start int)
RETURNS text
AS $$ SELECT plvstr.rpart($1,$2, $3, 1, false); $$
LANGUAGE SQL STABLE STRICT;

CREATE FUNCTION plvstr.rpart(str text, div text)
RETURNS text
AS $$ SELECT plvstr.rpart($1,$2, 1, 1, false); $$
LANGUAGE SQL STABLE STRICT;

CREATE FUNCTION plvstr.lstrip(str text, substr text, num int)
RETURNS text
AS '$libdir/orafunc','plvstr_lstrip'
LANGUAGE C STABLE STRICT;

CREATE FUNCTION plvstr.lstrip(str text, substr text)
RETURNS text
AS $$ SELECT plvstr.lstrip($1, $2, 1); $$
LANGUAGE SQL STABLE STRICT;

CREATE FUNCTION plvstr.rstrip(str text, substr text, num int)
RETURNS text
AS '$libdir/orafunc','plvstr_rstrip'
LANGUAGE C STABLE STRICT;

CREATE FUNCTION plvstr.rstrip(str text, substr text)
RETURNS text
AS $$ SELECT plvstr.rstrip($1, $2, 1); $$
LANGUAGE SQL STABLE STRICT;

CREATE FUNCTION plvstr.rvrs(str text, start int, _end int)
RETURNS text
AS '$libdir/orafunc','plvstr_rvrs'
LANGUAGE C STABLE;

CREATE FUNCTION plvstr.rvrs(str text, start int)
RETURNS text
AS $$ SELECT plvstr.rvrs($1,$2,NULL);$$
LANGUAGE SQL STABLE STRICT;

CREATE FUNCTION plvstr.rvrs(str text)
RETURNS text
AS $$ SELECT plvstr.rvrs($1,1,NULL);$$
LANGUAGE SQL STABLE STRICT;

DROP SCHEMA plvchr CASCADE;

CREATE SCHEMA plvchr;

CREATE FUNCTION plvchr.nth(str text, n int)
RETURNS text
AS '$libdir/orafunc','plvchr_nth'
LANGUAGE C STABLE STRICT;

CREATE FUNCTION plvchr.first(str text)
RETURNS varchar
AS '$libdir/orafunc','plvchr_first'
LANGUAGE C STABLE STRICT;

CREATE FUNCTION plvchr.last(str text)
RETURNS varchar
AS '$libdir/orafunc','plvchr_last'
LANGUAGE C STABLE STRICT;

CREATE FUNCTION plvchr._is_kind(str text, kind int)
RETURNS bool
AS '$libdir/orafunc','plvchr_is_kind_a'
LANGUAGE C STABLE STRICT;

CREATE FUNCTION plvchr._is_kind(c int, kind int)
RETURNS bool
AS '$libdir/orafunc','plvchr_is_kind_i'
LANGUAGE C STABLE STRICT;

CREATE FUNCTION plvchr.is_blank(c int)
RETURNS BOOL
AS $$ SELECT plvchr._is_kind($1, 1);$$
LANGUAGE SQL STABLE STRICT;

CREATE FUNCTION plvchr.is_blank(c text)
RETURNS BOOL
AS $$ SELECT plvchr._is_kind($1, 1);$$
LANGUAGE SQL STABLE STRICT;

CREATE FUNCTION plvchr.is_digit(c int)
RETURNS BOOL
AS $$ SELECT plvchr._is_kind($1, 2);$$
LANGUAGE SQL STABLE STRICT;

CREATE FUNCTION plvchr.is_digit(c text)
RETURNS BOOL
AS $$ SELECT plvchr._is_kind($1, 2);$$
LANGUAGE SQL STABLE STRICT;

CREATE FUNCTION plvchr.is_quote(c int)
RETURNS BOOL
AS $$ SELECT plvchr._is_kind($1, 3);$$
LANGUAGE SQL STABLE STRICT;

CREATE FUNCTION plvchr.is_quote(c text)
RETURNS BOOL
AS $$ SELECT plvchr._is_kind($1, 3);$$
LANGUAGE SQL STABLE STRICT;

CREATE FUNCTION plvchr.is_other(c int)
RETURNS BOOL
AS $$ SELECT plvchr._is_kind($1, 4);$$
LANGUAGE SQL STABLE STRICT;

CREATE FUNCTION plvchr.is_other(c text)
RETURNS BOOL
AS $$ SELECT plvchr._is_kind($1, 4);$$
LANGUAGE SQL STABLE STRICT;

CREATE FUNCTION plvchr.is_letter(c int)
RETURNS BOOL
AS $$ SELECT plvchr._is_kind($1, 5);$$
LANGUAGE SQL STABLE STRICT;

CREATE FUNCTION plvchr.is_letter(c text)
RETURNS BOOL
AS $$ SELECT plvchr._is_kind($1, 5);$$
LANGUAGE SQL STABLE STRICT;

CREATE FUNCTION plvchr.char_name(c text)
RETURNS varchar
AS '$libdir/orafunc','plvchr_char_name'
LANGUAGE C STABLE STRICT;

CREATE FUNCTION plvstr.left(str text, n int)
RETURNS varchar
AS '$libdir/orafunc', 'plvstr_left'
LANGUAGE C STABLE STRICT;

CREATE FUNCTION plvstr.right(str text, n int)
RETURNS varchar
AS '$libdir/orafunc','plvstr_right'
LANGUAGE C STABLE STRICT;

CREATE FUNCTION plvchr.quoted1(str text)
RETURNS varchar
AS $$SELECT E'\''||$1||E'\'';$$
LANGUAGE SQL STABLE STRICT;

CREATE FUNCTION plvchr.quoted2(str text)
RETURNS varchar
AS $$SELECT '"'||$1||'"';$$
LANGUAGE SQL STABLE STRICT;

CREATE FUNCTION plvchr.stripped(str text, char_in text)
RETURNS varchar
AS $$ SELECT TRANSLATE($1, 'A'||$2, 'A'); $$
LANGUAGE SQL STABLE STRICT;

