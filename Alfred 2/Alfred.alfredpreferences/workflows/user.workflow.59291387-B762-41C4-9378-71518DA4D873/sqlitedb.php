<?php

class SQLiteDB extends SQLite3 {

	private $select = '*';
	private $where = 1;
	private $from = null;
	private $order = "";
	private $group ="";
	private $set;
	private $cache;
	private $data;
	private $bundle;
	private $path;
	private $home;

	function __construct( $a = "database.db" )
	{
		require_once('workflows.php');
		$w = new Workflows();

		$this->cache  = $w->cache();
		$this->data   = $w->data();
		$this->bundle = $w->bundle();
		$this->path   = $w->path();
		$this->home   = $w->home();

		if ( file_exists( $this->data.'/'.$a ) ):
			$a = $this->data.'/'.$a;
		elseif ( file_exists( $this->cache.'/'.$a ) ):
			$a = $this->cache.'/'.$a;
		elseif ( file_exists( $this->path.'/'.$a ) ):
			$a = $this->path.'/'.$a;
		elseif ( file_exists( $a ) ):
			// do nothing.
		else:
			$a = $this->data.'/'.$a;
		endif;

		$this->open( $a );
	}

	public function select( $select )
	{
		if ( is_array( $select ) ):
			$this->select = implode( ",", $select );
		elseif ( is_string( $select ) ):
			$this->select = $select;
		else:
			exit('select function expects parameter 1 to be of type string or of type array');
		endif;

		return $this;
	}

	public function from( $from )
	{
		if ( is_array( $from ) ):
			$this->from = implode( ",", $from );
		elseif ( is_string( $from ) ):
			$this->from = $from;
		else:
			exit('from function expects parameter 1 to be of type string or of type array');
		endif;

		return $this;
	}

	public function where( $field, $value, $comparison="=" )
	{
		if ( !is_string( $field ) ):
			exit( 'where function expects parameter 1 to be of type string' );
		elseif ( !is_string( $value ) ):
			exit( 'where function expects parameter 2 to be of type string' );
		elseif ( !is_string( $comparison ) ):
			exit( 'where function expects parameter 3 to be of type string' );
		endif;

		$this->where = 'WHERE `'.$field.'` '.$comparison.' "'.$value.'"';

		return $this;
	}

	public function and_where( $field, $value, $comparison="=" )
	{
		if ( !is_string( $field ) ):
			exit( 'where function expects parameter 1 to be of type string' );
		elseif ( !is_string( $value ) ):
			exit( 'where function expects parameter 2 to be of type string' );
		elseif ( !is_string( $comparison ) ):
			exit( 'where function expects parameter 3 to be of type string' );
		endif;

		if ( $this->where == 1 ):
			exit( 'Cannot use and_where function when no previous where statement has been declared' );
		endif;

		$this->where .= ' AND `'.$field.'` '.$comparison.' "'.$value.'"';

		return $this;
	}

	public function or_where( $field, $value, $comparison="=" )
	{
		if ( !is_string( $field ) ):
			exit( 'where function expects parameter 1 to be of type string' );
		elseif ( !is_string( $value ) ):
			exit( 'where function expects parameter 2 to be of type string' );
		elseif ( !is_string( $comparison ) ):
			exit( 'where function expects parameter 3 to be of type string' );
		endif;

		if ( $this->where == 1 ):
			exit( 'Cannot use or_where function when no previous where statement has been declared' );
		endif;

		$this->where .= ' OR `'.$field.'` '.$comparison.' "'.$value.'"';

		return $this;
	}

	public function like( $field, $value )
	{
		if ( !is_string( $field ) ):
			exit( 'where function expects parameter 1 to be of type string' );
		elseif ( !is_string( $value ) ):
			exit( 'where function expects parameter 2 to be of type string' );
		endif;

		if ( is_numeric( $this->where ) ):
			$this->where = ' WHERE `'.$field.'` LIKE "%'.$value.'%"';
		else:
			$this->where .= ' AND `'.$field.'` LIKE "%'.$value.'%"';
		endif;

		return $this;
	}

	public function or_like( $field, $value )
	{
		if ( !is_string( $field ) ):
			exit( 'where function expects parameter 1 to be of type string' );
		elseif ( !is_string( $value ) ):
			exit( 'where function expects parameter 2 to be of type string' );
		endif;

		if ( is_numeric( $this->where ) ):
			$this->where = ' WHERE `'.$field.'` LIKE "%'.$value.'%"';
		else:
			$this->where .= ' OR `'.$field.'` LIKE "%'.$value.'%"';
		endif;

		return $this;
	}

	public function order_by( $field, $order='ASC' )
	{
		if ( !is_string( $field ) ):
			exit( 'order_by function expects parameter 1 to be of type string' );
		endif;
		if ( !is_string( $order ) ):
			exit( 'order_by function expects parameter 2 to be of type string' );
		endif;

		$this->order = ' ORDER BY `'.$field.'` '.$order;

		return $this;
	}

	public function group_by( $field )
	{
		if ( !is_string( $field ) ):
			exit( 'order_by function expects parameter 1 to be of type string' );
		endif;

		$this->group = ' GROUP BY `'.$field.'`';

		return $this;
	}

	public function get( $table=null )
	{
		if ( is_string( $table ) ):
			$this->from = $table;
		elseif ( is_null( $table ) ):
			if ( is_null( $this->from ) ):
				exit( 'no table has been selected to perform query against' );
			endif;
		else:
			exit( 'get functions expects parameter 1 to be of type string' );
		endif;

		if ( is_numeric( $this->where ) ):
			$this->where = 'WHERE 1';
		endif;

		$query = "SELECT ".$this->select." FROM `".$this->from."` ".$this->where." ".$this->group." ".$this->order;
		$results = $this->query( $query );
		$return = array();

		while( $result = $results->fetchArray( SQLITE3_ASSOC ) ):
			array_push( $return, $result );
		endwhile;

		return json_decode( json_encode( $return ) );
	}

	public function delete( $table=null )
	{
		if ( is_string( $table ) ):
			$this->from = $table;
		elseif ( is_null( $table ) ):
			if ( is_null( $this->from ) ):
				exit( 'no table has been selected to perform query against' );
			endif;
		else:
			exit( 'delete functions expects parameter 1 to be of type string' );
		endif;

		$query = "DELETE FROM ".$this->from." ".$this->where;
		$this->query( $query );
	}

	public function insert( $data, $table=null )
	{
		if ( is_string( $table ) ):
			$this->from = $table;
		elseif ( is_null( $table ) ):
			if ( is_null( $this->from ) ):
				exit( 'no table has been selected to perform query against' );
			endif;
		elseif ( !is_array( $data ) ):
			exit( 'insert functions expects parameter 1 to be of type array' );
		else:
			exit( 'insert functions expects parameter 1 to be of type string' );
		endif;

		$fields = array_keys( $data );
		$values = array_values( $data );

		array_walk( $fields, array( $this, 'wrap' ), "`" );
		array_walk( $values, array( $this, 'wrap' ) );

		$fields = implode( ',', $fields );
		$values = implode( ',', $values );

		$query = "INSERT OR REPLACE INTO `".$this->from."` ( ".$fields." ) VALUES ( ".$values." )";
		$this->query( $query );
	}

	private function wrap( &$item, $key, $wrapper="'" )
	{
		$item = "$wrapper".mysql_escape_string( $item )."$wrapper";
	}

	public function update( $data, $table=null )
	{
		if ( is_string( $table ) ):
			$this->from = $table;
		elseif ( is_null( $table ) ):
			if ( is_null( $this->from ) ):
				exit( 'no table has been selected to perform query against' );
			endif;
		elseif ( !is_array( $data ) ):
			exit( 'update functions expects parameter 1 to be of type array' );
		else:
			exit( 'update functions expects parameter 1 to be of type string' );
		endif;

		if ( $this->where == 1 ):
			$this->where == "WHERE 1";
		endif;

		$query = "UPDATE `".$this->from."` SET ".$this->set." ".$this->where;
		$this->query( $query );
	}

	public function create_table( $data, $table=null )
	{
		if ( is_string( $table ) ):
			$this->from = $table;
		elseif ( is_null( $table ) ):
			if ( is_null( $this->from ) ):
				exit( 'no table has been selected to perform query against' );
			endif;
		elseif ( !is_array( $data ) ):
			exit( 'update functions expects parameter 1 to be of type array' );
		endif;

		$create = array();
		foreach( $data as $field ):
			$temp = key( $data )." ".$field;
			array_push( $create, $temp );
			next( $data );
		endforeach;
		$create = implode( ',', $create );

		$query = "CREATE TABLE IF NOT EXISTS `".$this->from."` ( ".$create." )";
		$this->query( $query );
	}

	public function drop_table( $table=null )
	{
		if ( is_null( $table ) ):
			exit( 'drop expects parameter 1 to be of type string' );
		endif;

		$query = "DROP TABLE IF EXISTS ".$table;
		$this->query( $query );
	}

	public function truncate( $table=null )
	{
		if ( is_null( $table ) ):
			exit( 'truncate expects parameter 1 to be of type string' );
		endif;

		$query = "DELETE FROM ".$table;
		$this->query( $query );
	}

	function __destruct()
	{
		$this->close();
	}

}