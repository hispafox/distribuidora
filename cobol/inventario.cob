       IDENTIFICATION DIVISION.
       PROGRAM-ID. INVENTARIO.
      *================================================================
      * Inventario de productos -- distribuidora.
      * GnuCOBOL, formato fijo.
      * Operaciones: (A)lta, (L)istado, (B)usqueda por codigo, (S)alir.
      * Codigo de producto: 6 caracteres.
      *   Posiciones 1-2: categoria (ej: HW=hardware, EL=electrico)
      *   Posiciones 3-6: numero secuencial dentro de la categoria
      *================================================================

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT FICHERO-INV ASSIGN TO "inventario.dat"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  FICHERO-INV.
       01  REGISTRO-INV.
           05  RI-CODIGO        PIC X(6).
           05  RI-DESCRIPCION   PIC X(30).
           05  RI-STOCK         PIC 9(5).
           05  RI-PRECIO        PIC 9(5)V99.

       WORKING-STORAGE SECTION.
       01  WS-OPCION            PIC X(1).
       01  WS-CODIGO            PIC X(6).
       01  WS-DESCRIPCION       PIC X(30).
       01  WS-STOCK             PIC 9(5).
       01  WS-PRECIO            PIC 9(5)V99.
       01  WS-ENCONTRADO        PIC X(1) VALUE 'N'.
       01  WS-EOF               PIC X(1) VALUE 'N'.
       01  WS-PRECIO-DISPLAY    PIC ZZ9.99.

       PROCEDURE DIVISION.
       INICIO.
           PERFORM UNTIL WS-OPCION = 'S'
               DISPLAY "==================================="
               DISPLAY "  INVENTARIO DISTRIBUIDORA"
               DISPLAY "==================================="
               DISPLAY "(A)lta  (L)istado  (B)usqueda  (S)alir: "
               ACCEPT WS-OPCION
               EVALUATE WS-OPCION
                   WHEN 'A'
                       PERFORM ALTA-PRODUCTO
                   WHEN 'L'
                       PERFORM LISTAR-PRODUCTOS
                   WHEN 'B'
                       PERFORM BUSCAR-PRODUCTO
                   WHEN 'S'
                       CONTINUE
                   WHEN OTHER
                       DISPLAY "Opcion no valida: " WS-OPCION
               END-EVALUATE
           END-PERFORM
           STOP RUN.

       ALTA-PRODUCTO.
           DISPLAY "Codigo (6 car., 2 primeras=categoria): "
           ACCEPT WS-CODIGO
           DISPLAY "Descripcion: "
           ACCEPT WS-DESCRIPCION
           DISPLAY "Stock inicial: "
           ACCEPT WS-STOCK
           DISPLAY "Precio unitario (EUR, ej: 018.50): "
           ACCEPT WS-PRECIO
           OPEN EXTEND FICHERO-INV
               MOVE WS-CODIGO       TO RI-CODIGO
               MOVE WS-DESCRIPCION  TO RI-DESCRIPCION
               MOVE WS-STOCK        TO RI-STOCK
               MOVE WS-PRECIO       TO RI-PRECIO
               WRITE REGISTRO-INV
           CLOSE FICHERO-INV
           DISPLAY "Alta registrada: " WS-CODIGO.

       LISTAR-PRODUCTOS.
           DISPLAY "--- LISTADO DE PRODUCTOS ---"
           OPEN INPUT FICHERO-INV
               MOVE 'N' TO WS-EOF
               READ FICHERO-INV
                   AT END MOVE 'S' TO WS-EOF
               END-READ
               PERFORM UNTIL WS-EOF = 'S'
                   MOVE RI-PRECIO TO WS-PRECIO-DISPLAY
                   DISPLAY RI-CODIGO "  "
                           RI-DESCRIPCION "  "
                           "Stock: " RI-STOCK "  "
                           "Precio: " WS-PRECIO-DISPLAY
                   READ FICHERO-INV
                       AT END MOVE 'S' TO WS-EOF
                   END-READ
               END-PERFORM
           CLOSE FICHERO-INV
           DISPLAY "--- FIN LISTADO ---".

       BUSCAR-PRODUCTO.
           DISPLAY "Codigo a buscar (6 caracteres): "
           ACCEPT WS-CODIGO
           MOVE 'N' TO WS-ENCONTRADO
           OPEN INPUT FICHERO-INV
               MOVE 'N' TO WS-EOF
               READ FICHERO-INV
                   AT END MOVE 'S' TO WS-EOF
               END-READ
               PERFORM UNTIL WS-EOF = 'S'
                   IF RI-CODIGO = WS-CODIGO
                       MOVE RI-PRECIO TO WS-PRECIO-DISPLAY
                       DISPLAY "Codigo:      " RI-CODIGO
                       DISPLAY "Descripcion: " RI-DESCRIPCION
                       DISPLAY "Stock:       " RI-STOCK
                       DISPLAY "Precio:      " WS-PRECIO-DISPLAY " EUR"
                       MOVE 'S' TO WS-ENCONTRADO
                   END-IF
                   READ FICHERO-INV
                       AT END MOVE 'S' TO WS-EOF
                   END-READ
               END-PERFORM
           CLOSE FICHERO-INV
           IF WS-ENCONTRADO = 'N'
               DISPLAY "Producto no encontrado: " WS-CODIGO
           END-IF.
