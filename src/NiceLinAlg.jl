import LinearAlgebra: ishermitian, checksquare, checkpositivedefinite
import LinearAlgebra: cholesky, Cholesky

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