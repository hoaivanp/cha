module Rules.General where

import Derivation
import Goal
import Rules.Utils
import Tactic
import Term

-- H >> C
--   H >> t = t in C
-- Uses: WITNESS
generalWITNESS :: Term -> PrlTactic
generalWITNESS w (Goal ctx t) =
    return $ Result
        { resultGoals = [ Goal ctx (Eq e e t) ]
        , resultEvidence = \d -> case d of
            [d] -> WITNESS w d
            _ -> error "General.WITNESS: Invalid evidence!"
        }

{-
-- TODO: Custom operators

-- H >> C
--   opid is a lemma proving L
--   H, L >> C
-- Uses: CUT
generalCUT :: RefinerConfig -> Guid -> PrlTactic
-}

-- H >> C
--   H(i) = C
-- Uses: VAR
generalHYP :: Target -> PrlTactic
generalHYP target (Goal ctx t) =
    case nth (irrelevant t) target ctx of
        Just t' | t == t' ->
            return $ Result
                { resultGoals = []
                , resultEvidence = \d ->
                    case d of
                        [] -> VAR target
                        _  -> error "General.HYP: Invalid evidence!"
                }
        _ -> fail "General.HYP does not apply."


-- H >> C
--   H(i) = C
-- Uses: VAR_EQ
generalHYPEQ :: PrlTactic

{-
-- TODO Customer operators

-- There isn't a nice rule for this really. This rule
-- finds every occurence of the Guid given and expands
-- it according to what the refiner config says is its
-- extract.
generalUNFOLD :: RefinerConfig -> Guid -> PrlTactic
-}
