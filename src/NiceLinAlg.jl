import LinearAlgebra: Hermitian, Symmetric, UpperTriangular, LowerTriangular
import LinearAlgebra: cholesky!, _chol!, Cholesky, checkpositivedefinite


function cholesky!(A::Union{Hermitian{NiceNumber,S}, Symmetric{NiceNumber,S}} where S, ::Val{false}=Val(false); check::Bool = true)
    C, info = _chol!(A.data, A.uplo == 'U' ? UpperTriangular : LowerTriangular)
    check && checkpositivedefinite(info)
    return Cholesky(C.data, A.uplo, info)
end