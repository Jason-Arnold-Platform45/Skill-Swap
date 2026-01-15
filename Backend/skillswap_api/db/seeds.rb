# Create test users
user1 = User.find_or_create_by!(email: "alice@example.com") do |user|
  user.username = "alice"
  user.password = "password123"
end

user2 = User.find_or_create_by!(email: "bob@example.com") do |user|
  user.username = "bob"
  user.password = "password123"
end

user3 = User.find_or_create_by!(email: "charlie@example.com") do |user|
  user.username = "charlie"
  user.password = "password123"
end

# Create skills
[
  { user: user1, title: "Python Programming", description: "Expert in Python, Django, and data science libraries", skill_type: "offer" },
  { user: user1, title: "Web Design", description: "Looking to learn modern UI/UX design principles", skill_type: "request" },
  { user: user2, title: "Graphic Design", description: "Professional graphic design and branding expertise", skill_type: "offer" },
  { user: user2, title: "Spanish Language", description: "Want to learn conversational Spanish", skill_type: "request" },
  { user: user3, title: "Guitar Playing", description: "Can teach beginner to intermediate guitar", skill_type: "offer" },
  { user: user3, title: "Digital Marketing", description: "Interested in learning SEO and social media marketing", skill_type: "request" },
  { user: user1, title: "Mobile App Development", description: "Experienced with React Native and Flutter", skill_type: "offer" },
  { user: user2, title: "Photography", description: "Passionate about landscape and portrait photography", skill_type: "offer" },
].each do |skill_attrs|
  user = skill_attrs.delete(:user)
  user.skills.find_or_create_by!(skill_attrs)
end

puts "Seeded #{User.count} users and #{Skill.count} skills"
