lgm_path = "lgm."
local base = require(tostring(lgm_path) .. "lgm-base")
local entity = require(tostring(lgm_path) .. "lgm-entity")
local entityset = require(tostring(lgm_path) .. "lgm-entityset")
local segment = require(tostring(lgm_path) .. "lgm-segment")
local vector = require(tostring(lgm_path) .. "lgm-vector")
return {
  base = base,
  Entity = entity.Entity,
  EntitySet = entityset.EntitySet,
  Segment = segment.Segment,
  Vector = vector.Vector
}
