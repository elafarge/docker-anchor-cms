<?php

return array(
	'default' => 'mysql',
	'prefix' => 'anchor_',
	'connections' => array(
		'mysql' => array(
			'driver' => 'mysql',
			'hostname' => '0.0.0.0',
			'port' => 3306,
			'username' => 'anchorapp',
			'password' => 'db_pwd',
			'database' => 'anchor',
			'charset' => 'utf8'
		)
	)
);
