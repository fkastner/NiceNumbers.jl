using LinearAlgebra: Hermitian, Symmetric, UpperTriangular, LowerTriangular
using LinearAlgebra: _chol!, Cholesky, checkpositivedefinite
import LinearAlgebra: cholesky!

@static if VERSION < v"1.8.0-DEV.1120"
    function cholesky!(A::Union{Hermitian{NiceNumber}, Symmetric{NiceNumber}}, ::Val{false}=Val(false); check::Bool = true)
        C, info = _chol!(A.data, A.uplo == 'U' ? UpperTriangular : LowerTriangular)
        check && checkpositivedefinite(info)
        return Cholesky(C.data, A.uplo, info)
    end
else
    using LinearAlgebra: NoPivot
    function cholesky!(A::Union{Hermitian{NiceNumber}, Symmetric{NiceNumber}}, ::NoPivot=NoPivot(); check::Bool = true)
        C, info = _chol!(A.data, A.uplo == 'U' ? UpperTriangular : LowerTriangular)
        check && checkpositivedefinite(info)
        return Cholesky(C.data, A.uplo, info)
    end
end
