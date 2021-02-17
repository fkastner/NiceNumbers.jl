import LinearAlgebra: ishermitian, checksquare, checkpositivedefinite, checknonsingular
import LinearAlgebra: cholesky, Cholesky
import LinearAlgebra: lu, LU

function cholesky(A::Matrix{NiceNumber})
    n = checksquare(A)
    !ishermitian(A) && checkpositivedefinite(-1)

    C = copy(A)

    for k = 1:n
        for j = 1:k-1
            C[k,k] -= C[k,j]*C[k,j]'
        end
        C[k,k] = sqrt(C[k,k])
        for i = k+1:n
            for j=1:k-1
                C[i,k] -= C[i,j]*C[k,j]'
            end
            C[i,k] /= C[k,k]
        end
    end

    return Cholesky(C, 'L', 0)
end

value(::Val{T}) where T = T
function lu(A::Matrix{NiceNumber}, pivot::Union{Val{false}, Val{true}}=Val(false))
    n = checksquare(A)
    C = copy(A)
    pivots = zeros(Int,n)

    for i = 1:n
        pivots[i] = i
        # Find pivot point
        if value(pivot)
            pivots[i] = last(findmax(abs.(C[i:n,i]))) + i-1
        end
        iszero(C[pivots[i],i]) && checknonsingular(i, pivot)
        # Swap lines
        if i != pivots[i]
            for j = 1:n
                C[pivots[i],j], C[i,j] = C[i,j], C[pivots[i],j]
            end
        end
        # Compute U
        for j = i:n
            for k = 1:i-1
                C[i,j] -= C[i,k]*C[k,j]
            end
        end
        # Compute L
        for j = i+1:n
            for k = 1:i-1
                C[j,i] -= C[j,k]*C[k,i]
            end
            C[j,i] /= C[i,i]
        end
    end

    return LU{NiceNumber,Matrix{NiceNumber}}(C, pivots, 0)
end