var documenterSearchIndex = {"docs":
[{"location":"functions/#Function-reference-1","page":"Index","title":"Function reference","text":"","category":"section"},{"location":"functions/#","page":"Index","title":"Index","text":"DocTestSetup = :(using NiceNumbers)","category":"page"},{"location":"functions/#Macro-related-1","page":"Index","title":"Macro related","text":"","category":"section"},{"location":"functions/#","page":"Index","title":"Index","text":"nice\n@nice","category":"page"},{"location":"functions/#NiceNumbers.nice","page":"Index","title":"NiceNumbers.nice","text":"nice(x, mod = @__MODULE__)\n\nIf x is an expression it replaces all occuring numbers by NiceNumbers.\n\nIf x is a number it turns it into a NiceNumber.\n\nOtherwise it does nothing.\n\n\n\n\n\n","category":"function"},{"location":"functions/#NiceNumbers.@nice","page":"Index","title":"NiceNumbers.@nice","text":"@nice\n\nReturn equivalent expression with all numbers converted to NiceNumbers.\n\n\n\n\n\n","category":"macro"},{"location":"functions/#Miscellaneous-Helper-Functions-1","page":"Index","title":"Miscellaneous Helper Functions","text":"","category":"section"},{"location":"functions/#","page":"Index","title":"Index","text":"isrational\nNiceNumbers.reduce_root\nNiceNumbers.nthroot","category":"page"},{"location":"functions/#NiceNumbers.isrational","page":"Index","title":"NiceNumbers.isrational","text":"isrational(n::NiceNumber)\n\nWhether n is purely rational, i.e. has no square root portion.\n\n\n\n\n\n","category":"function"},{"location":"functions/#NiceNumbers.reduce_root","page":"Index","title":"NiceNumbers.reduce_root","text":"reduce_root(coeff, radicand)\n\nSimplifies the expression textrmcoeffcdotsqrttextrmradicand by factoring all remaining squares in radicand into coeff.\n\n\n\n\n\n","category":"function"},{"location":"functions/#NiceNumbers.nthroot","page":"Index","title":"NiceNumbers.nthroot","text":"nthroot(m::NiceNumber, n)\n\nReturns the nth root of m. Works by repeatedly determining the square root and thus only for powers of two.\n\n\n\n\n\n","category":"function"},{"location":"functions/#Index-1","page":"Index","title":"Index","text":"","category":"section"},{"location":"functions/#","page":"Index","title":"Index","text":"","category":"page"},{"location":"#NiceNumbers.jl-1","page":"Home","title":"NiceNumbers.jl","text":"","category":"section"},{"location":"#","page":"Home","title":"Home","text":"The nicest numbers in Julia","category":"page"},{"location":"#","page":"Home","title":"Home","text":"This package implements a number type to represent numbers you can safely give to your students to work with.","category":"page"},{"location":"#","page":"Home","title":"Home","text":"The goal is that when common linear algebra or numerical algorithms work using NiceNumbers that then one can be sure that the algorithm can be reasonably easy worked through by hand with the given numbers.","category":"page"},{"location":"#","page":"Home","title":"Home","text":"Nice numbers as implemented in this package consist of a rational part and a square root part with a rational coefficient. Thus every NiceNumber is specified using two Rational{Int}s and one Int.","category":"page"},{"location":"#Installation-1","page":"Home","title":"Installation","text":"","category":"section"},{"location":"#","page":"Home","title":"Home","text":"Since this package isn't registered yet, you have to use the GitHub URL of the repository:","category":"page"},{"location":"#","page":"Home","title":"Home","text":"(v1.3) pkg> add https://github.com/fkastner/NiceNumbers.jl","category":"page"},{"location":"#Usage-Example-1","page":"Home","title":"Usage Example","text":"","category":"section"},{"location":"#","page":"Home","title":"Home","text":"julia> using NiceNumbers\n\njulia> n = NiceNumber(2,3,5)\nNice number:\n   2 + 3 ⋅ √5\n\njulia> n^2\nNice number:\n   49 + 12 ⋅ √5\n\njulia> m = NiceNumber(3//5)\nNice number:\n   3//5\n\njulia> n+m, n-m, n*m, n/m\n(13//5 + 3 ⋅ √5, 7//5 + 3 ⋅ √5, 6//5 + 9//5 ⋅ √5, 10//3 + 5 ⋅ √5)\n\njulia> sqrt(m)\nNice number:\n   1//5 ⋅ √15\n\njulia> sqrt(n)\nERROR: That's not nice anymore!\n[...]","category":"page"},{"location":"#","page":"Home","title":"Home","text":"There is also a macro to simplify working with nice numbers:","category":"page"},{"location":"#","page":"Home","title":"Home","text":"julia> using LinearAlgebra\n\njulia> n = norm([4,12,3] * √2)\n18.38477631085024\n\njulia> @nice m = norm([4,12,3] * √2)\nNice number:\n   13 ⋅ √2\n\njulia> n == m\ntrue","category":"page"},{"location":"#","page":"Home","title":"Home","text":"For further examples see the examples section of the documentation, especially the Example: SVD.","category":"page"},{"location":"example_svd/#Example:-SVD-1","page":"Example: SVD","title":"Example: SVD","text":"","category":"section"},{"location":"example_svd/#","page":"Example: SVD","title":"Example: SVD","text":"Building an SVD exercise","category":"page"},{"location":"example_svd/#","page":"Example: SVD","title":"Example: SVD","text":"In this example we want to see how we can use NiceNumbers to construct an exercise for a singular value decomposition.","category":"page"},{"location":"example_svd/#The-Math-1","page":"Example: SVD","title":"The Math","text":"","category":"section"},{"location":"example_svd/#","page":"Example: SVD","title":"Example: SVD","text":"For a given matrix AinmathbbR^mtimes n, mgeq n, we try to find a decomposition of the form","category":"page"},{"location":"example_svd/#","page":"Example: SVD","title":"Example: SVD","text":"A = U(Sigma 0)^top V^top","category":"page"},{"location":"example_svd/#","page":"Example: SVD","title":"Example: SVD","text":"where U and V are orthogonal (or unitary) square matrices and Sigma is a diagonal matrix with the singular values of A on the diagonal.","category":"page"},{"location":"example_svd/#Using-NiceNumbers-to-build-the-exercise-1","page":"Example: SVD","title":"Using NiceNumbers to build the exercise","text":"","category":"section"},{"location":"example_svd/#","page":"Example: SVD","title":"Example: SVD","text":"To construct a workable exercise we start from the decomposition and construct A. First we need to load the relevant packages:","category":"page"},{"location":"example_svd/#","page":"Example: SVD","title":"Example: SVD","text":"julia> using NiceNumbers, LinearAlgebra","category":"page"},{"location":"example_svd/#","page":"Example: SVD","title":"Example: SVD","text":"Decide on an orthogonal basis in mathbbR^m (here m=3)","category":"page"},{"location":"example_svd/#","page":"Example: SVD","title":"Example: SVD","text":"julia> u1 = NiceNumber[3,12,4]\n3-element Array{NiceNumber,1}:\n  3\n 12\n  4\n\njulia> u2 = NiceNumber[-4,0,3]\n3-element Array{NiceNumber,1}:\n -4\n  0\n  3\n\njulia> u3 = cross(u1,u2)\n3-element Array{NiceNumber,1}:\n  36\n -25\n  48","category":"page"},{"location":"example_svd/#","page":"Example: SVD","title":"Example: SVD","text":"and take note of their norms","category":"page"},{"location":"example_svd/#","page":"Example: SVD","title":"Example: SVD","text":"julia> n1 = norm(u1)\nNice number:\n   13\n\njulia> n2 = norm(u2)\nNice number:\n   5\n\njulia> n3 = norm(u3)\nNice number:\n   65\n\njulia> n3 == n1*n2\ntrue","category":"page"},{"location":"example_svd/#","page":"Example: SVD","title":"Example: SVD","text":"to construct U:","category":"page"},{"location":"example_svd/#","page":"Example: SVD","title":"Example: SVD","text":"julia> U = 1/n3 * [u1*n2 u2*n1 u3]\n3×3 Array{NiceNumber,2}:\n  3//13  -4//5  36//65\n 12//13      0  -5//13\n  4//13   3//5  48//65","category":"page"},{"location":"example_svd/#","page":"Example: SVD","title":"Example: SVD","text":"The same procedure can in principle be used to construct a second unitary matrix in mathbbR^ntimes n (here n=2):","category":"page"},{"location":"example_svd/#","page":"Example: SVD","title":"Example: SVD","text":"julia> V = 1//5* NiceNumber[-3 4;4 3]\n2×2 Array{NiceNumber,2}:\n -3//5  4//5\n  4//5  3//5","category":"page"},{"location":"example_svd/#","page":"Example: SVD","title":"Example: SVD","text":"Now we fix the singular values and construct some auxiliary matrices:","category":"page"},{"location":"example_svd/#","page":"Example: SVD","title":"Example: SVD","text":"julia> Σ = diagm(NiceNumber[13,5])\n2×2 Array{NiceNumber,2}:\n 13  0\n  0  5\n\njulia> S = [Σ;0 0]\n3×2 Array{NiceNumber,2}:\n 13  0\n  0  5\n  0  0\n\njulia> R = pinv(S)\n2×3 Array{NiceNumber,2}:\n 1//13     0  0\n     0  1//5  0","category":"page"},{"location":"example_svd/#","page":"Example: SVD","title":"Example: SVD","text":"And we're ready to construct our matrix A and it's pseudoinverse A^dagger:","category":"page"},{"location":"example_svd/#","page":"Example: SVD","title":"Example: SVD","text":"julia> A = U*S*V'\n3×2 Array{NiceNumber,2}:\n     -5      0\n -36//5  48//5\n      0      5\n\njulia> A⁺ = V*R*U'\n2×3 Array{NiceNumber,2}:\n -2929//21125  -36//845  1728//21125\n -1728//21125   48//845  1921//21125\n\njulia> float(A⁺) ≈ pinv(float(A))\ntrue","category":"page"}]
}
