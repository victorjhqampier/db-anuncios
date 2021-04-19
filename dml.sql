create table departamentos(/*P01*/
	departamento_id INT not null,
	departamento VARCHAR(60) not null,
    primary key (departamento_id)
);
create table provincias (/*P02*/
	provincia_id int not null,
	departamento_id int not null,
	provincia varchar(60) not null,
	foreign key (departamento_id) references departamentos (departamento_id),
	primary key (provincia_id)	
);
create table distritos(/*P03*/
	distrito_id int not null,
	provincia_id int not null,
	distrito varchar(60) not null,
	foreign key (provincia_id) references provincias (provincia_id),
	primary key (distrito_id)
);
/*ACCOUNT MANAGEMEBT SERVICE*/

/* Las personas puenden ser naturales o juridicas*/
create table personas(
	persona_id int not null auto_increment,
    distrito_id int not null,
	documento VARCHAR(11) not null unique,
	nombres VARCHAR(60) not null,
	paterno VARCHAR(60) not null,
	materno VARCHAR(60) default'',
	nacimiento DATE	default '',
	sexo int not null CHECK(sexo >= 1 and sexo <=3), /*1:Male, 2: Female, 3: None, */
    telefono VARCHAR(20) default '',
    fotografia VARCHAR(70) default '',
    direccion VARCHAR(70) default '',
    correo VARCHAR(60) default '',
	created_at TIMESTAMP default CURRENT_TIMESTAMP,
	updated_at TIMESTAMP default CURRENT_TIMESTAMP,
    foreign key (distrito_id) references distritos(distrito_id),
	primary key (persona_id)
);
/*para penalidades*/
create table permisos(/*---para los permisos de los botones leer, crear, actualizar, eliminar,*/
	permiso_id int not null,
	binario int not null,
	permiso varchar (60) not null,
	primary key (permiso_id)
);

create table cuentas (
	cuenta_id int not null auto_increment,
	persona_id INT not null,
    permiso_id int not null, /*Lectura o escritura*/
	correo VARCHAR(100) not null unique,
	pass VARCHAR(100) not null,
    passini VARCHAR(100) not null,
	estado BOOL default true, /*puede estar suspendido*/
	created_at timestamp not null default current_timestamp,
    updated_at timestamp not null default current_timestamp,
    foreign key (persona_id)  references personas (persona_id),
    foreign key (permiso_id) references permisos(permiso_id),
	primary key (cuenta_id)
);

/*PUBLISHMENT SERVICE*/

create table categorias( /*compcategorias_C08*/
	categoria_id int not null,
	categoria VARCHAR(50) not null,
	primary key (categoria_id)
);

create table grupos( /*compsubcategorias_C09*/
	grupo_id int not null,
	grupo VARCHAR(50) not null,
    muestra varchar (50) not null,
	primary key (grupo_id)
);
select * from grupos;
create table subcategorias ( /*compsubcategorias_C09*/
	subcategoria_id int not null auto_increment,
	categoria_id int not null,
    grupo_id int not null,
	foreign key (categoria_id) references categorias (categoria_id),
    foreign key (grupo_id) references grupos (grupo_id),
	primary key (subcategoria_id)
);
/*Debido que hay muchas personas que no desean utilizar la tecnologia para publicar, asi que,
ellos pagan cierto monto por publicacion, de echo ellos escriben un borrador, y el personal encargado de la tienda lo formaliza, antes de publicar.
entonces NUESTRO SISTEMA esta preparado para eso, entonces habrá sucursales con sus respectivos encargados(cuentas de usuario que administran la sucrusal)
ademas que, las personas interesadas independientes podran crear sus cuentas personales y no ser administrador
*/
create table sucursales (
	sucursal_id int not null auto_increment,
	distrito_id INT not null,
    numero int not null unique,
    logo varchar(80) not null,
	nombre VARCHAR(80) not null,
	direccion VARCHAR(80) not null,/*direccion de la sucursal*/
	estado boolean not null default true,
	created_at TIMESTAMP not null default current_timestamp,
    updated_at TIMESTAMP not null default current_timestamp,
    foreign key (distrito_id) references distritos (distrito_id),
    primary key (sucursal_id)
);

create table monedas (/*soles y dolares*/
	moneda_id int not null,
    simbolo varchar(5) not null,
    moneda varchar(30) not null,
    primary key (moneda_id)
);

/*Un anuncio puede estar en muchas sucursales/ciudades = costo mas alto*/
create table publicaciones (
	publicacion_id int not null auto_increment,
    cuenta_id int not null,
    subcategoria_id int not null,
    item_name varchar(50) not null,
    descripcion text not null,
    num_contact varchar (20) not null, /*algun numero de cell*/
    other_contact varchar(30) default '',
    precio double not null default 0.0,/*-1 = para usar en casos de intercambio; 0 = gratis*/
    start_date date not null, /*fecha de inicio*/
    end_date date not null, /*fecha de vencimiento*/
    item_status bool not null default true, /*TRUE = ACITVO, FALSE = vencido*/
    created_at TIMESTAMP not null default current_timestamp, /* para auditoria*/
    updated_at TIMESTAMP not null default current_timestamp, /*para auditoria*/
    foreign key (cuenta_id) references cuentas (cuenta_id),
    foreign key (subcategoria_id) references subcategorias (subcategoria_id),
    primary key (publicacion_id)
);
/*una publicacion puede tener muchas imagenes*/
create table imagenes(
	imagen_id int not null auto_increment,
    publicacion_id int not null,
    imagen varchar(150) not null,/*nombre de la imagen cifrado*/
    foreign key (publicacion_id) references publicaciones (publicacion_id),
    primary key (imagen_id)
);

select * from personas;