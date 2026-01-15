# puts "🌱 Seeding database..."

# Skill.destroy_all
# User.destroy_all

# # Create test users
# user1 = User.create!(
#   username: "alice",
#   email: "alice@example.com",
#   password: "Password123",
#   password_confirmation: "Password123"
# )

# user2 = User.create!(
#   username: "bob",
#   email: "bob@example.com",
#   password: "Password123",
#   password_confirmation: "Password123"
# )

# user3 = User.create!(
#   username: "charlie",
#   email: "charlie@example.com",
#   password: "Password123",
#   password_confirmation: "Password123"
# )

# # Create skills
# skills = [
#   { user: user1, title: "Python Programming", description: "Expert in Python, Django, and data science libraries", skill_type: "offer" },
#   { user: user1, title: "Web Design", description: "Looking to learn modern UI/UX design principles", skill_type: "request" },

#   { user: user2, title: "Graphic Design", description: "Professional graphic design and branding expertise", skill_type: "offer" },
#   { user: user2, title: "Spanish Language", description: "Want to learn conversational Spanish", skill_type: "request" },

#   { user: user3, title: "Guitar Playing", description: "Can teach beginner to intermediate guitar", skill_type: "offer" },
#   { user: user3, title: "Digital Marketing", description: "Interested in learning SEO and social media marketing", skill_type: "request" },

#   { user: user1, title: "Mobile App Development", description: "Experienced with React Native and Flutter", skill_type: "offer" },
#   { user: user2, title: "Photography", description: "Passionate about landscape and portrait photography", skill_type: "offer" }
# ]

# skills.each do |attrs|
#   Skill.create!(attrs)
# end

# puts "✅ Seeded #{User.count} users and #{Skill.count} skills"
