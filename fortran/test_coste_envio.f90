! ================================================================
! Characterization tests del coste de envio -- distribuidora.
!
! Congela el comportamiento actual del calculo: entradas conocidas
! con su salida real. Es la red de M8: antes de modernizar, capturas
! lo que el programa hace HOY, para detectar si una version nueva
! cambia algun resultado.
!
! Test driver en FORTRAN puro, usa el modulo `envio` (envio_mod.f90).
! Compilar y ejecutar:
!     gfortran -o test_coste_envio envio_mod.f90 test_coste_envio.f90
!     ./test_coste_envio
!
! En produccion se usaria pFUnit (estilo JUnit, sobre gfortran) o
! FRUIT (mas ligero, dos ficheros sin dependencias). Aqui usamos un
! driver casero para no depender de instalar un framework: lo que
! importa es el PATRON de characterization test, no la libreria.
! ================================================================

program test_coste_envio
    use envio
    implicit none

    integer :: fallos
    real, parameter :: TOL = 0.001   ! tolerancia para comparar reales

    fallos = 0

    write(*,*) "=== CHARACTERIZATION TESTS: coste de envio ==="
    write(*,*) ""

    ! --- Peso volumetrico ---
    call check("vol 40x30x25 = 6.0",   peso_volumetrico(40.0, 30.0, 25.0), 6.0,  fallos)
    call check("vol 10x10x10 = 0.2",   peso_volumetrico(10.0, 10.0, 10.0), 0.2,  fallos)
    call check("vol 50x40x30 = 12.0",  peso_volumetrico(50.0, 40.0, 30.0), 12.0, fallos)

    ! --- Coste por tramos (peso de tarificacion ya calculado) ---
    call check("tramo 0-5:  2.0 kg = 5.00",   coste_envio(2.0),  5.00,  fallos)
    call check("tramo 5-15: 6.0 kg = 10.80",  coste_envio(6.0),  10.80, fallos)
    call check("tramo 15-30: 20.0 kg = 28.00", coste_envio(20.0), 28.00, fallos)
    call check("tramo >30:  40.0 kg = 44.00",  coste_envio(40.0), 44.00, fallos)

    ! --- Bordes exactos (el caso limite que M8 obliga a probar) ---
    call check("borde 5.0 kg  = 12.50 (tramo 0-5)",  coste_envio(5.0),  12.50, fallos)
    call check("borde 15.0 kg = 27.00 (tramo 5-15)", coste_envio(15.0), 27.00, fallos)
    call check("borde 30.0 kg = 42.00 (tramo 15-30)", coste_envio(30.0), 42.00, fallos)

    ! --- Caso completo: el paquete del README (3 kg, 40x30x25) ---
    ! peso_vol = 6.0; peso_tarif = max(3.0, 6.0) = 6.0; coste = 6.0 * 1.80 = 10.80
    call check("caso README: tarif 6.0 = 10.80", coste_envio(6.0), 10.80, fallos)

    write(*,*) ""
    if (fallos == 0) then
        write(*,*) "TODOS LOS TESTS PASAN"
    else
        write(*,'(A,I0,A)') " ", fallos, " TEST(S) FALLAN"
        call exit(1)
    end if

contains

    subroutine check(nombre, obtenido, esperado, fallos)
        character(len=*), intent(in) :: nombre
        real, intent(in) :: obtenido, esperado
        integer, intent(inout) :: fallos

        if (abs(obtenido - esperado) <= TOL) then
            write(*,'(A,A)') "  [OK]   ", nombre
        else
            write(*,'(A,A,A,F8.3,A,F8.3)') "  [FALLA] ", nombre, &
                "  obtenido=", obtenido, " esperado=", esperado
            fallos = fallos + 1
        end if
    end subroutine check

end program test_coste_envio
