maciej = User.create(first_name: 'Maciej', last_name: 'Lorens', email: 'mckl@poczta.fm', password: '1234567890', admin: true)
jacek = User.create(first_name: 'Jacek', last_name: 'Mazur', email: 'jmazur@pro.onet.pl ', password: '1234567890', admin: true)
tomek = User.create(first_name: 'Tomasz', last_name: 'Somer', email: 'tomasz@somer.pl', password: '1234567890', admin: false)

client = User.create(first_name: 'Franek', last_name: 'Golas', email: 'franek@golas.fm', password: '1234567890', admin: false)

200.times do
  Order.create(
    type: %w(MetalOrder FurnitureOrder).sample,
    user_id: client.id,
    description: 'Lorem ipsum dolor sit amet ' + SecureRandom.hex(10),
    quantity: rand(100),
    expense: rand(60000).to_f / 100,
    price: rand(100000).to_f / 100,
    purchaser: %w(WSK inne).sample,
    delivery_request_date: Time.now + rand(5).days,
    confirmation_date: Time.now + rand(20).days,
    status: %w(inquiry proposition not_confirmed ordered delivered deleted).sample,
    created_at: rand(200).days.ago
  )
end
