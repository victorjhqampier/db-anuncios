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
/* todas las cuentas creadas en el sistema */
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
    numero int not null unique, /*numero unico de los administradores*/
    logo varchar(80) not null,
	nombre VARCHAR(80) not null,
	direccion VARCHAR(80) not null,/*direccion de la sucursal*/
	estado boolean not null default true, /*púed estar baneado*/
	created_at TIMESTAMP not null default current_timestamp,
    updated_at TIMESTAMP not null default current_timestamp,
    foreign key (distrito_id) references distritos (distrito_id),
    primary key (sucursal_id)
);
/*cuentas que administran una sucursal*/
create table x_cuenta_administradores(
	cuenta_id int not null,
    sucursal_id int not null,
    foreign key (cuenta_id) references cuentas(cuenta_id),
    foreign key (sucursal_id) references sucursales (sucursal_id),
    primary key (cuenta_id, sucursal_id)    
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
    moneda_id int not null default 1,
    item_name varchar(50) not null,
    descripcion text not null,
    num_contact varchar (70) not null, /*algun numero de cell del anunciante*/
    other_contact varchar(150) default '',
    precio double not null default 0.0,/*-1 = para usar en casos de intercambio; 0 = gratis*/
    start_date date not null, /*fecha de inicio*/
    end_date date not null, /*fecha de vencimiento*/
    item_status bool not null default true, /*TRUE = ACITVO, FALSE = vencido --- ESTO SE ACTUALIZA COMPROBANDO LAS FECHAS*/
    created_at TIMESTAMP not null default current_timestamp, /* para auditoria*/
    updated_at TIMESTAMP not null default current_timestamp, /*para auditoria*/
    foreign key (cuenta_id) references cuentas (cuenta_id),
    foreign key (subcategoria_id) references subcategorias (subcategoria_id),
    foreign key (moneda_id) references monedas (moneda_id),
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

/*UNA PUBLICACION PUEDE ESTARBEN VARIOS SUCURSALES || POR DEFECTO EL ANUNCIO VA ASOCIADO A LA SUCURSAL SERCANA*/
/*esto se conoce como catalogo*/
create table x_anuncios (
	publicacion_id int not null, /*estos resgistros se deben borrar cuando la publicacion tiene un estado = false*/
    sucursal_id int not null,
    estado bool default true, /* cuando el anuncio fue sensurado*/
    foreign key (publicacion_id) references publicaciones (publicacion_id),
    foreign key (sucursal_id) references sucursales (sucursal_id),
    primary key (publicacion_id, sucursal_id)    
);

/* vista vara ver las subcategorias*/
create view v_subcategorias as
	select su.*, g.grupo, g.muestra
	from subcategorias su
	inner join grupos g on su.grupo_id= g.grupo_id;

/*vista para ver los anuncios para un determinado sucursal*/
create view v_catalogos as
    select x.publicacion_id, x.sucursal_id , x.estado anun_status, 
	p.cuenta_id, p.subcategoria_id, p.moneda_id, p.item_name, p.descripcion, p.num_contact, p.other_contact, p.precio, p.start_date, p.end_date, p.item_status
	from x_anuncios x
	inner join publicaciones p on x.publicacion_id = p.publicacion_id
	where x.estado = true;