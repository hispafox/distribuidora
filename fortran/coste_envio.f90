! ================================================================
! Calculo del coste de envio -- distribuidora.
! gfortran, formato libre (Fortran 90).
!
! Programa principal interactivo. La logica de calculo vive en el
! modulo `envio` (fichero envio_mod.f90), para que sea reutilizable
! y testeable.
!
! Compilar:
!     gfortran -o coste_envio envio_mod.f90 coste_envio.f90
!     ./coste_envio
! ================================================================

program calcular_envio
    use envio
    implicit none

    real :: peso_real_kg, alto_cm, ancho_cm, largo_cm
    real :: p_volum, peso_tarif, coste_total

    write(*,*) "=== CALCULO COSTE ENVIO ==="
    write(*,*) "Peso real del paquete (kg):"
    read(*,*) peso_real_kg

    write(*,*) "Dimensiones del paquete (cm) -- alto, ancho, largo:"
    read(*,*) alto_cm, ancho_cm, largo_cm

    ! Calcular peso volumetrico y peso de tarificacion
    p_volum     = peso_volumetrico(alto_cm, ancho_cm, largo_cm)
    peso_tarif  = max(peso_real_kg, p_volum)
    coste_total = coste_envio(peso_tarif)

    ! Resultado
    write(*,'(A,F8.3,A)') "  Peso real:          ", peso_real_kg, " kg"
    write(*,'(A,F8.3,A)') "  Peso volumetrico:   ", p_volum,      " kg"
    write(*,'(A,F8.3,A)') "  Peso tarificacion:  ", peso_tarif,   " kg"
    write(*,'(A,F8.2,A)') "  COSTE ENVIO:        ", coste_total,  " EUR"

end program calcular_envio
