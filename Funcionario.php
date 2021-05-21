<?php

class Funcionario 
{

    public function calcularSalario($cargo, $dpto, $totalHorasExtras, $bonificacao)
    {
        if(strcmp($dpto, "ti") == 0) {
            if(strcmp($cargo, "fullstack1")) {
                $salario = 3000;
                $horaExtra = 15;
                return $salario + ($totalHorasExtras * $horaExtra); 
            }

            if(strcmp($cargo, "dev_junior")) {
                $salario = 4000;
                $horaExtra = 20;
                return $salario + ($totalHorasExtras * $horaExtra); 
            }

            if(strcmp($cargo, "dev_pleno")) {
                $salario = 5000;
                $horaExtra = 25;
                return $salario + ($totalHorasExtras * $horaExtra); 
            }

            if(strcmp($cargo, "analista")) {
                $salario = 6000;
                $horaExtra = 30;
                return $salario + ($totalHorasExtras * $horaExtra); 
            }
        }

        if(strcmp($dpto, "comercial") == 0) {
            if(strcmp($cargo, "vendedor_junior")) {
                $salario = 3000;
                $horaExtra = 15;
                return $salario + ($totalHorasExtras * $horaExtra) + $bonificaca; 
            }

            if(strcmp($cargo, "vendedor_pleno")) {
                $salario = 4000;
                $horaExtra = 20;
                return $salario + ($totalHorasExtras * $horaExtra) + $bonificaca; 
            }

            if(strcmp($cargo, "vendedor_senior")) {
                $salario = 5000;
                $horaExtra = 25;
                return $salario + ($totalHorasExtras * $horaExtra) + $bonificaca; 
            }

            if(strcmp($cargo, "gestor")) {
                $salario = 6000;
                $horaExtra = 30;
                return $salario + ($totalHorasExtras * $horaExtra) + $bonificaca; 
            }
        }

    }

}