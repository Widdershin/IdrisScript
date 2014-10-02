module IdrisScript.Arrays

import IdrisScript

%access public

empty : IO (JSValue JSArray)
empty = do
  arr <- mkForeign (FFun "new Array()" [] FPtr)
  return $ MkJSObject arr

infixr 7 ++
(++) : JSValue JSArray -> JSValue JSArray -> IO (JSValue JSArray)
arr ++ arr' = do
  res <- mkForeign (
      FFun "%0.concat(%1)" [FPtr, FPtr] FPtr
    ) (unpack arr) (unpack arr')
  return $ MkJSObject res

insert : Nat -> JSValue t -> JSValue JSArray -> IO (JSValue JSArray)
insert idx val arr = do
  mkForeign (
      FFun "%0[%1] = %2" [FPtr, FInt, FPtr] FUnit
    ) (unpack arr) (cast idx) (unpack val)
  return arr

indexOf : JSValue a -> JSValue JSArray -> IO Int
indexOf val arr =
  mkForeign (
      FFun "%0.indexOf(%1)" [FPtr, FPtr] FInt
    ) (unpack arr) (unpack val)

join : JSValue JSArray -> IO (JSValue JSArray)
join arr = do
  res <- mkForeign (FFun "%0.join()" [FPtr] FPtr) (unpack arr)
  return $ MkJSObject res

reverse : JSValue JSArray -> IO (JSValue JSArray)
reverse arr = do
  res <- mkForeign (FFun "%0.reverse()" [FPtr] FPtr) (unpack arr)
  return $ MkJSObject res

sort : JSValue JSArray -> IO (JSValue JSArray)
sort arr = do
  res <- mkForeign (FFun "%0.sort()" [FPtr] FPtr) (unpack arr)
  return $ MkJSObject res

push : JSValue JSArray -> JSValue t -> IO ()
push arr val =
  mkForeign (
      FFun "%0.push(%1)" [FPtr, FPtr] FUnit
    ) (unpack arr) (unpack val)

pop : JSValue JSArray -> IO (Maybe (t : JSType ** JSValue t))
pop arr = do
  elm <- mkForeign (FFun "%0.pop()" [FPtr] FPtr) (unpack arr)
  case !(typeOf elm) of
       JSUndefined => return Nothing
       _           => return $ Just !(pack elm)

infixl 6 !!
(!!) : JSValue JSArray -> Nat -> IO (Maybe (t : JSType ** JSValue t))
arr !! idx = do
  elm <- mkForeign (
      FFun "%0[%1]" [FPtr, FInt] FPtr
    ) (unpack arr) (cast idx)
  case !(typeOf elm) of
       JSUndefined => return Nothing
       _           => return $ Just !(pack elm)

shift : JSValue JSArray -> IO (Maybe (t ** JSValue t))
shift arr = do
  elm <- mkForeign (FFun "%0.shift()" [FPtr] FPtr) (unpack arr)
  case !(typeOf elm) of
       JSUndefined => return Nothing
       _           => return $ Just !(pack elm)

unshift : JSValue JSArray -> JSValue a -> IO Nat
unshift arr val = do
  res <- mkForeign (
      FFun "%0.unshift(%1)" [FPtr, FPtr] FInt
    ) (unpack arr) (unpack val)
  return $ cast {to=Nat} res
