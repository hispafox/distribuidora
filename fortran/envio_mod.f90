! ================================================================
! Modulos del calculo de coste de envio -- distribuidora.
! gfortran, formato libre (Fortran 90).
!
! Las funciones de calculo viven aqui, separadas del programa
! principal, para que sean reutilizables y testeables.
! Tanto coste_envio.f90 (la app) como test_coste_envio.f90 (los
! tests) hacen `use envio`.
!
! Esta separacion modulo / programa es, en si misma, el primer paso
! de "hacer el codigo testeable" que ensena M8: no puedes caracterizar
! una funcion que esta encerrada dentro de un `program`.
! ================================================================

module tarifas
    implicit none

    ! Tarifas en EUR/kg por tramo de peso de tarificacion
    real, parameter :: TARIFA_0_5   = 2.50   ! hasta 5 kg
    real, parameter :: TARIFA_5_15  = 1.80   ! 5 kg hasta 15 kg
    real, parameter :: TARIFA_15_30 = 1.40   ! 15 kg hasta 30 kg
    real, parameter :: TARIFA_MAS30 = 1.10   ! mas de 30 kg

    ! Factor volumetrico estandar logistica: largo*ancho*alto (cm3) / 5000 = kg equivalente
    real, parameter :: DIVISOR_VOLUM = 5000.0

end module tarifas


module envio
    use tarifas
    implicit none

contains

    function peso_volumetrico(alto_cm, ancho_cm, largo_cm) result(peso_volum)
        real, intent(in) :: alto_cm, ancho_cm, largo_cm
        real :: peso_volum

        peso_volum = (alto_cm * ancho_cm * largo_cm) / DIVISOR_VOLUM
    end function peso_volumetrico


    function coste_envio(peso_tarif_kg) result(coste)
        real, intent(in) :: peso_tarif_kg
        real :: coste

        if (peso_tarif_kg <= 5.0) then
            coste = peso_tarif_kg * TARIFA_0_5
        else if (peso_tarif_kg <= 15.0) then
            coste = peso_tarif_kg * TARIFA_5_15
        else if (peso_tarif_kg <= 30.0) then
            coste = peso_tarif_kg * TARIFA_15_30
        else
            coste = peso_tarif_kg * TARIFA_MAS30
        end if
    end function coste_envio

end module envio
