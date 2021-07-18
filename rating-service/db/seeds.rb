# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Status.create(rank: 'no_rank', limit: 1, score: 0)
Status.create(rank: 'bronze', limit: 3, score: 3)
Status.create(rank: 'silver', limit: 5, score: 15)
Status.create(rank: 'gold', limit: 7, score: 30)
Status.create(rank: 'platinum', limit: 10, score: 50)
