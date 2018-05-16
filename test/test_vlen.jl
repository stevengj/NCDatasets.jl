using Test
import NCDatasets
using NCDatasets

filename = tempname()
#@show filename

dimlen = 10

T = Int32
data = Vector{Vector{T}}(dimlen)
for i = 1:length(data)
    data[i] = T.(collect(1:i) + 100 * i) 
end


varname = "varname"
vlentypename = "name-vlen"

# write data

ds = NCDatasets.Dataset(filename,"c",format=:netcdf4)
ds.dim["casts"] = dimlen
v = NCDatasets.defVar(ds,varname,Vector{T},("casts",); typename = vlentypename)
@test eltype(v.var) == Vector{T}

#for i = 1:dimlen
#    v.var[i] = data[i]
#end
v.var[:] = data
close(ds)


# load data

ds = NCDatasets.Dataset(filename)
vv = variable(ds,"varname")
@test eltype(vv) == Vector{T}
data2 = vv[:]

@test data == data2
close(ds)

#@show data
#@show data2
