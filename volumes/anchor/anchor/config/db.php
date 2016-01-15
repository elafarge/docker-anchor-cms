<?php

return array(
	'default' => 'mysql',
	'prefix' => 'anchor_',
	'connections' => array(
		'mysql' => array(
			'driver' => 'mysql',
			'hostname' => '172.17.0.3',
			'port' => 3306,
			'username' => 'anchor',
			'password' => 'newpwd',
			'database' => 'anchor',
			'charset' => 'utf8'
		)
	)
);