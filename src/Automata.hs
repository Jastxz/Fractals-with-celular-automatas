module Automata(
  numCelulas,
  numeroRegla,
  propiedadesRegla,
  automataRandom,
  automataPreparado,
  aplicaRegla,
) where

import Data.Matrix
import Tipos
import Utiles

numCelulas :: Int
numCelulas = 100

numeroRegla :: Int -> Int
numeroRegla r
  | r==0 = 30
  | r==1 = 90
  | r==2 = 150
  | otherwise = error $ "No se reconoce el valor introducido para traducirlo a regla. El valor: " ++ show r

propiedadesRegla :: Int -> [String]
propiedadesRegla regla
  | numeroRegla regla == 30 = [senConIni, topTrans, punDen]
  | numeroRegla regla == 90 = [dimFractal]
  | numeroRegla regla == 150 = [senConIni, topTrans, punDen]
  | otherwise = error $ "A la funcion propiedadesRegla le entra una regla no valida. La regla: " ++ show regla
  where
    senConIni = "Sensitivity to initial conditions"
    topTrans = "Topologically transitive"
    punDen = "Periodic points are dense"
    dimFractal = "Fractal dimension"

automataRandom :: Int -> Automata
automataRandom semilla = fromList mitad mitad listaAl
    where
        mitad = numCelulas `div` 2
        listaAleatorios = take (numCelulas^2) $ generaAleatorios semilla
        listaAl = map binario listaAleatorios

automataPreparado :: Automata
automataPreparado = setElem 1 pos matrizBase
  where
    mitad = numCelulas `div` 2
    centro = mitad `div` 2
    pos = (1, centro)
    matrizBase = zero mitad mitad

aplicaRegla :: Int -> Int -> Automata -> Automata
aplicaRegla fila regla automata = aplicaRegla' regla automata (fila, base)
  where
    (base, tam) = rangos automata

aplicaRegla' :: Int -> Automata -> Pos -> Automata
aplicaRegla' regla automata pos@(f,c)
  | f>tam = automata
  | c==tam = na
  | otherwise = aplicaRegla' regla na (f,c+1)
  where
    (base, tam) = rangos automata
    fa = f-1
    central = automata ! (fa,c)
    iz
      | c==base = automata ! (fa,tam)
      | otherwise = automata ! (fa,c-1)
    der
      | c==tam = automata ! (fa,base)
      | otherwise = automata ! (fa,c+1)
    ne
      | regla==18 = regla18 iz central der
      | regla==22 = regla22 iz central der
      | regla==30 = regla30 iz central der
      | regla==41 = regla41 iz central der
      | regla==45 = regla45 iz central der
      | regla==60 = regla60 iz central der
      | regla==90 = regla90 iz central der
      | regla==106 = regla106 iz central der
      | regla==122 = regla122 iz central der
      | regla==126 = regla126 iz central der
      | regla==146 = regla146 iz central der
      | regla==150 = regla150 iz central der
      | regla==154 = regla154 iz central der
      | otherwise = error $ "A la funcion aplicaRegla le entra una regla no valida. La regla: " ++ show regla
    na = setElem ne pos automata

regla18 :: Int -> Int -> Int -> Int
regla18 izq central der
  | evaluaEntorno izq central der == "100" = 1
  | evaluaEntorno izq central der == "001" = 1
  | otherwise = 0

regla22 :: Int -> Int -> Int -> Int
regla22 izq central der
  | evaluaEntorno izq central der == "100" = 1
  | evaluaEntorno izq central der == "010" = 1
  | evaluaEntorno izq central der == "001" = 1
  | otherwise = 0

regla30 :: Int -> Int -> Int -> Int
regla30 izq central der
  | evaluaEntorno izq central der == "100" = 1
  | evaluaEntorno izq central der == "011" = 1
  | evaluaEntorno izq central der == "010" = 1
  | evaluaEntorno izq central der == "001" = 1
  | otherwise = 0

regla41 :: Int -> Int -> Int -> Int
regla41 izq central der
  | evaluaEntorno izq central der == "101" = 1
  | evaluaEntorno izq central der == "011" = 1
  | evaluaEntorno izq central der == "000" = 1

regla45 :: Int -> Int -> Int -> Int
regla45 izq central der
  | evaluaEntorno izq central der == "101" = 1
  | evaluaEntorno izq central der == "011" = 1
  | evaluaEntorno izq central der == "010" = 1
  | evaluaEntorno izq central der == "000" = 1
  | otherwise = 0

regla60 :: Int -> Int -> Int -> Int
regla60 izq central der
  | evaluaEntorno izq central der == "101" = 1
  | evaluaEntorno izq central der == "100" = 1
  | evaluaEntorno izq central der == "011" = 1
  | evaluaEntorno izq central der == "010" = 1
  | otherwise = 0

regla90 :: Int -> Int -> Int -> Int
regla90 izq central der
  | evaluaEntorno izq central der == "110" = 1
  | evaluaEntorno izq central der == "100" = 1
  | evaluaEntorno izq central der == "011" = 1
  | evaluaEntorno izq central der == "001" = 1
  | otherwise = 0

regla106 :: Int -> Int -> Int -> Int
regla106 izq central der
  | evaluaEntorno izq central der == "110" = 1
  | evaluaEntorno izq central der == "101" = 1
  | evaluaEntorno izq central der == "011" = 1
  | evaluaEntorno izq central der == "001" = 1
  | otherwise = 0

regla122 :: Int -> Int -> Int -> Int
regla122 izq central der
  | evaluaEntorno izq central der == "010" = 0
  | evaluaEntorno izq central der == "000" = 0
  | otherwise = 1

regla126 :: Int -> Int -> Int -> Int
regla126 izq central der
  | evaluaEntorno izq central der == "000" = 0
  | otherwise = 1

regla146 :: Int -> Int -> Int -> Int
regla146 izq central der
  | evaluaEntorno izq central der == "111" = 1
  | evaluaEntorno izq central der == "100" = 1
  | evaluaEntorno izq central der == "001" = 1
  | otherwise = 0

regla150 :: Int -> Int -> Int -> Int
regla150 izq central der
  | evaluaEntorno izq central der == "111" = 1
  | evaluaEntorno izq central der == "100" = 1
  | evaluaEntorno izq central der == "010" = 1
  | evaluaEntorno izq central der == "001" = 1
  | otherwise = 0

regla154 :: Int -> Int -> Int -> Int
regla154 izq central der
  | evaluaEntorno izq central der == "111" = 1
  | evaluaEntorno izq central der == "100" = 1
  | evaluaEntorno izq central der == "011" = 1
  | evaluaEntorno izq central der == "001" = 1
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
