module Automata
  ( numCelulas,
    numeroRegla,
    propiedadesRegla,
    automataRandom,
    automataPreparado,
    aplicaRegla,
  )
where

import Data.Matrix
import Tipos
import Utiles

numCelulas :: String -> Int
numCelulas tam
  | tam == "Very big" = 500
  | tam == "Big" = 200
  | tam == "Standard" = 100
  | tam == "Small" = 50
  | otherwise = error $ "Tamaño especificado en numCelulas incorrecto. Tamaño: " ++ tam

numeroRegla :: Int -> Int
numeroRegla r
  | r == 0 = 30
  | r == 1 = 73
  | r == 2 = 90
  | r == 3 = 105
  | r == 4 = 122
  | r == 5 = 124
  | r == 6 = 126
  | r == 7 = 150
  | r == 8 = 193
  | r == 9 = 195
  | otherwise = error $ "No se reconoce el valor introducido para traducirlo a regla. El valor: " ++ show r

propiedadesRegla :: Int -> [String]
propiedadesRegla regla
  | numeroRegla regla == 30 = [senConIni, topTrans, punDen]
  | numeroRegla regla == 73 = [dimFractal++" ~1.7771.", boxC1, boxC2]
  | numeroRegla regla == 90 = [dimFractal++" ~1.5401.", boxC1, boxC2]
  | numeroRegla regla == 105 = [dimFractal++" ~1.7751.", boxC1, boxC2]
  | numeroRegla regla == 122 = [efecto]
  | numeroRegla regla == 124 = [dimFractal++" ~1.778.", boxC1, boxC2]
  | numeroRegla regla == 126 = [variacion++" ~1.6657.", boxC1, boxC2]
  | numeroRegla regla == 150 = [dimFractal++" ~1.6407.", boxC1, boxC2]
  | numeroRegla regla == 193 = [dimFractal++" ~1.7598.", boxC1, boxC2]
  | numeroRegla regla == 195 = [variacion, dimFractal++" ~1.5708.", boxC1, boxC2]
  | otherwise = error $ "A la funcion propiedadesRegla le entra una regla no valida. La regla: " ++ show regla
  where
    senConIni = "-  Sensitivity to initial conditions"
    topTrans = "-  Topologically transitive"
    punDen = "-  Periodic points are dense"
    dimFractal = "-  Fractal dimension: "
    efecto = "-  Simply is an optic effect"
    variacion = "-  Sierpinski triangle variation"
    boxC1 = "Note: Calculated with box counting method"
    boxC2 = " and an error of ~|0.05|."

automataRandom :: Int -> String -> Automata
automataRandom semilla cels = fromList mitad mitad listaAl
  where
    celulas = numCelulas cels
    mitad = celulas `div` 2
    listaAleatorios = take (celulas ^ 2) $ generaAleatorios semilla
    listaAl = map binario listaAleatorios

automataPreparado :: String -> Automata
automataPreparado cels = setElem 1 pos matrizBase
  where
    mitad = numCelulas cels `div` 2
    centro = mitad `div` 2
    pos = (1, centro)
    matrizBase = zero mitad mitad

aplicaRegla :: Int -> Int -> Automata -> Automata
aplicaRegla fila regla automata = aplicaRegla' regla automata (fila, base)
  where
    (base, tam) = rangos automata

aplicaRegla' :: Int -> Automata -> Pos -> Automata
aplicaRegla' regla automata pos@(f, c)
  | f > tam = automata
  | c == tam = na
  | otherwise = aplicaRegla' regla na (f, c + 1)
  where
    (base, tam) = rangos automata
    fa = f -1
    central = automata ! (fa, c)
    iz
      | c == base = automata ! (fa, tam)
      | otherwise = automata ! (fa, c -1)
    der
      | c == tam = automata ! (fa, base)
      | otherwise = automata ! (fa, c + 1)
    ne
      | regla == 30 = regla30 iz central der
      | regla == 73 = regla73 iz central der
      | regla == 90 = regla90 iz central der
      | regla == 105 = regla105 iz central der
      | regla == 122 = regla122 iz central der
      | regla == 124 = regla124 iz central der
      | regla == 126 = regla126 iz central der
      | regla == 150 = regla150 iz central der
      | regla == 193 = regla193 iz central der
      | regla == 195 = regla195 iz central der
      | otherwise = error $ "A la funcion aplicaRegla le entra una regla no valida. La regla: " ++ show regla
    na = setElem ne pos automata

{- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Auxiliares
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -}

regla30 :: Int -> Int -> Int -> Int
regla30 izq central der
  | evaluaEntorno izq central der == "100" = 1
  | evaluaEntorno izq central der == "011" = 1
  | evaluaEntorno izq central der == "010" = 1
  | evaluaEntorno izq central der == "001" = 1
  | otherwise = 0

regla73 :: Int -> Int -> Int -> Int
regla73 izq central der
  | evaluaEntorno izq central der == "110" = 1
  | evaluaEntorno izq central der == "011" = 1
  | evaluaEntorno izq central der == "000" = 1
  | otherwise = 0

regla90 :: Int -> Int -> Int -> Int
regla90 izq central der
  | evaluaEntorno izq central der == "110" = 1
  | evaluaEntorno izq central der == "100" = 1
  | evaluaEntorno izq central der == "011" = 1
  | evaluaEntorno izq central der == "001" = 1
  | otherwise = 0

regla105 :: Int -> Int -> Int -> Int
regla105 izq central der
  | evaluaEntorno izq central der == "110" = 1
  | evaluaEntorno izq central der == "101" = 1
  | evaluaEntorno izq central der == "011" = 1
  | evaluaEntorno izq central der == "000" = 1
  | otherwise = 0

regla122 :: Int -> Int -> Int -> Int
regla122 izq central der
  | evaluaEntorno izq central der == "010" = 0
  | evaluaEntorno izq central der == "000" = 0
  | otherwise = 1

regla124 :: Int -> Int -> Int -> Int
regla124 izq central der
  | evaluaEntorno izq central der == "111" = 0
  | evaluaEntorno izq central der == "001" = 0
  | evaluaEntorno izq central der == "000" = 0
  | otherwise = 1

regla126 :: Int -> Int -> Int -> Int
regla126 izq central der
  | evaluaEntorno izq central der == "111" = 0
  | evaluaEntorno izq central der == "000" = 0
  | otherwise = 1

regla150 :: Int -> Int -> Int -> Int
regla150 izq central der
  | evaluaEntorno izq central der == "111" = 1
  | evaluaEntorno izq central der == "100" = 1
  | evaluaEntorno izq central der == "010" = 1
  | evaluaEntorno izq central der == "001" = 1
  | otherwise = 0

regla193 :: Int -> Int -> Int -> Int
regla193 izq central der
  | evaluaEntorno izq central der == "111" = 1
  | evaluaEntorno izq central der == "110" = 1
  | evaluaEntorno izq central der == "000" = 1
  | otherwise = 0

regla195 :: Int -> Int -> Int -> Int
regla195 izq central der
  | evaluaEntorno izq central der == "111" = 1
  | evaluaEntorno izq central der == "110" = 1
  | evaluaEntorno izq central der == "001" = 1
  | evaluaEntorno izq central der == "000" = 1
  | otherwise = 0

evaluaEntorno :: Int -> Int -> Int -> String
evaluaEntorno 1 1 1 = "111"
evaluaEntorno 1 1 0 = "110"
evaluaEntorno 1 0 1 = "101"
evaluaEntorno 1 0 0 = "100"
evaluaEntorno 0 1 1 = "011"
evaluaEntorno 0 1 0 = "010"
evaluaEntorno 0 0 1 = "001"
evaluaEntorno 0 0 0 = "000"
