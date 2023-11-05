
CREATE PROC sp_RegistrarUsuario(
@Nombres varchar(100),
@Apellidos varchar(100),
@Correo varchar(100),
@Clave varchar(100),
@Activo bit,
@Mensaje varchar(500) output,
@Resultado int output
)
AS
BEGIN
	SET @Resultado = 0

	IF NOT EXISTS (SELECT * FROM Usuario WHERE Correo = @Correo)
	BEGIN
		INSERT INTO Usuario(Nombres,Apellidos, Correo, Clave, Activo) VALUES
		(@Nombres, @Apellidos, @Correo, @Clave,@Activo)
		
		SET @Resultado = SCOPE_IDENTITY()
	END
	ELSE
		SET @Mensaje ='El correo del usuario ya existe'
END 
go

CREATE PROC sp_EditarUsuario(
@IdUsuario int,
@Nombres varchar(100),
@Apellidos varchar(100),
@Correo varchar(100),
@Activo bit,
@Mensaje varchar(500) output,
@Resultado int output
)
AS
BEGIN
	SET @Resultado = 0

	IF NOT EXISTS (SELECT * FROM Usuario WHERE Correo = @Correo and IdUsuario != @IdUsuario)
	BEGIN

		UPDATE top(1) Usuario SET
		Nombres = @Nombres,
		Apellidos = @Apellidos,
		Correo = @Correo,
		Activo = @Activo
		WHERE IdUsuario = @IdUsuario

		SET @Resultado = 1
	END

	ELSE
		SET @Mensaje ='El correo del usuario ya existe'
END 
go

CREATE PROC sp_RegistrarCategoria(
@Descripcion varchar(100),
@Activo bit,
@Mensaje varchar(500) output,
@Resultado int output
)
AS
BEGIN
	SET @Resultado = 0
	IF NOT EXISTS (SELECT * FROM CATEGORIA WHERE Descripcion = @Descripcion)
	BEGIN
		INSERT INTO CATEGORIA(Descripcion, Activo) 
		VALUES (@Descripcion, @Activo)
		
		SET @Resultado = SCOPE_IDENTITY()
	END
	ELSE
		SET @Mensaje ='La Categoria ya existe'
END
go

CREATE PROC sp_EditarCategoria(
@IdCategoria int,
@Descripcion varchar(100),
@Activo bit,
@Mensaje varchar(500) output,
@Resultado int output
)
AS
BEGIN
	SET @Resultado = 0
	IF NOT EXISTS (SELECT * FROM CATEGORIA WHERE Descripcion = @Descripcion and IdCategoria != @IdCategoria)
	BEGIN

		UPDATE top(1) CATEGORIA SET
		Descripcion = @Descripcion,
		Activo = @Activo
		WHERE IdCategoria = @IdCategoria

		SET @Resultado = 1
	END

	ELSE
		SET @Mensaje ='La Categoria ya existe'
END  
go

/*Para verificar que la categoria no este en un producto*/
CREATE PROC sp_EliminarCategoria(
@IdCategoria int,
@Mensaje varchar(500) output,
@Resultado int output
)
AS
BEGIN
	SET @Resultado = 0
	IF NOT EXISTS (SELECT * FROM PRODUCTO p  INNER JOIN CATEGORIA c ON c.IdCategoria = p.IdCategoria
					WHERE p.IdCategoria = @IdCategoria)
	BEGIN
		DELETE top(1) FROM CATEGORIA WHERE IdCategoria = @IdCategoria
		SET @Resultado = 1
	END
	ELSE
		SET @Mensaje ='La Categoria se encuentra relacionada a un producto'
END  
go


----------------

CREATE PROC sp_RegistrarMarca(
@Descripcion varchar(100),
@Activo bit,
@Mensaje varchar(500) output,
@Resultado int output
)
AS
BEGIN
	SET @Resultado = 0
	IF NOT EXISTS (SELECT * FROM MARCA WHERE Descripcion = @Descripcion)
	BEGIN
		INSERT INTO MARCA(Descripcion, Activo) 
		VALUES (@Descripcion, @Activo)
		
		SET @Resultado = SCOPE_IDENTITY()
	END
	ELSE
		SET @Mensaje ='La Marca ya existe'
END
go

CREATE PROC sp_EditarMarca(
@IdMarca int,
@Descripcion varchar(100),
@Activo bit,
@Mensaje varchar(500) output,
@Resultado int output
)
AS
BEGIN
	SET @Resultado = 0
	IF NOT EXISTS (SELECT * FROM MARCA WHERE Descripcion = @Descripcion and IdMarca != @IdMarca)
	BEGIN

		UPDATE top(1) MARCA SET
		Descripcion = @Descripcion,
		Activo = @Activo
		WHERE IdMarca = @IdMarca

		SET @Resultado = 1
	END

	ELSE
		SET @Mensaje ='La Marca ya existe'
END  
go

/*Para verificar que la Marca no este en un producto*/
CREATE PROC sp_EliminarMarca(
@IdMarca int,
@Mensaje varchar(500) output,
@Resultado int output
)
AS
BEGIN
	SET @Resultado = 0
	IF NOT EXISTS (SELECT * FROM PRODUCTO p  INNER JOIN MARCA m ON m.IdMarca = p.IdMarca
					WHERE p.IdMarca = @IdMarca)
	BEGIN
		DELETE top(1) FROM MARCA WHERE IdMarca = @IdMarca
		SET @Resultado = 1
	END
	ELSE
		SET @Mensaje ='La Marca se encuentra relacionada a un producto'
END  
go

CREATE PROC sp_RegistrarProducto(
@Nombre varchar(100),
@Descripcion varchar(100),
@IdMarca varchar(100),
@IdCategoria varchar(100),
@Precio decimal(10,2),
@Stock int,
@Activo bit,
@Mensaje varchar(500) output,
@Resultado int output
)
AS
BEGIN
	SET @Resultado = 0
	IF NOT EXISTS (SELECT * FROM PRODUCTO WHERE Nombre = @Nombre)
	BEGIN
		INSERT INTO PRODUCTO(Nombre, Descripcion, IdMarca, IdCategoria, Precio, Stock, Activo) VALUES
		(@Nombre, @Descripcion, @IdMarca, @IdCategoria,@Precio,@Stock, @Activo)
		
		SET @Resultado = SCOPE_IDENTITY()
	END
	ELSE
		SET @Mensaje ='El producto ya existe'
END 
go

CREATE PROC sp_EditarProducto(
@IdProducto int,
@Nombre varchar(100),
@Descripcion varchar(100),
@IdMarca varchar(100),
@IdCategoria varchar(100),
@Precio decimal(10,2),
@Stock int,
@Activo bit,
@Mensaje varchar(500) output,
@Resultado int output
)
AS
BEGIN
	SET @Resultado = 0
	IF NOT EXISTS (SELECT * FROM PRODUCTO WHERE Nombre = @Nombre and IdProducto != @IdProducto)
	BEGIN

		UPDATE top(1) PRODUCTO SET
		Nombre = @Nombre,
		Descripcion = @Descripcion,
		IdMarca = @IdMarca,
		IdCategoria = @IdCategoria,
		Precio = @Precio,
		Stock = @Stock,
		Activo = @Activo
		WHERE IdProducto = @IdProducto

		SET @Resultado = 1
	END

	ELSE
		SET @Mensaje ='El producto ya existe'
END 
go

CREATE PROC sp_EliminarProducto(
@IdProducto int,
@Mensaje varchar(500) output,
@Resultado int output
)
AS
BEGIN
	SET @Resultado = 0
	IF NOT EXISTS (SELECT * FROM DETALLE_VENTA dv 
					INNER JOIN PRODUCTO p ON p.IdProducto = dv.IdProducto
					WHERE p.IdProducto = @IdProducto)
	BEGIN
		DELETE top(1) FROM PRODUCTO WHERE IdProducto = @IdProducto
		SET @Resultado = 1
	END
	ELSE
		SET @Mensaje ='El producto se encuentra relacionado a una venta'
END  
go

CREATE PROC sp_RegistrarCliente(
@Nombres varchar(100),
@Apellidos varchar(100),
@Correo varchar(100),
@Clave varchar(100),
@Mensaje varchar(500) output,
@Resultado int output
)
AS
BEGIN
	SET @Resultado = 0

	IF NOT EXISTS (SELECT * FROM Cliente WHERE Correo = @Correo)
	BEGIN
		INSERT INTO Cliente(Nombres,Apellidos, Correo, Clave, Reestablecer) VALUES
		(@Nombres, @Apellidos, @Correo, @Clave, 0)
		
		SET @Resultado = SCOPE_IDENTITY()
	END
	ELSE
		SET @Mensaje ='El correo del usuario ya existe'
END 
go