const mongoose = require('mongoose');
require('dotenv').config();

const connectDB = require('./connection');
const User = require('../models/User');
const AdminUser = require('../models/AdminUser');
const PropertyCategory = require('../models/PropertyCategory');
const Amenity = require('../models/Amenity');
const Property = require('../models/Property');
const Booking = require('../models/Booking');
const Payment = require('../models/Payment');
const Review = require('../models/Review');
const SupportTicket = require('../models/SupportTicket');

// Sample data
const sampleCategories = [
  { name: 'Beach', emoji: '🏖️', description: 'Beachfront properties', icon: 'beach', color: '#3B82F6' },
  { name: 'Mountain', emoji: '🏔️', description: 'Mountain and ski properties', icon: 'mountain', color: '#10B981' },
  { name: 'City', emoji: '🏙️', description: 'Urban city properties', icon: 'city', color: '#6B7280' },
  { name: 'Countryside', emoji: '🌾', description: 'Rural countryside properties', icon: 'countryside', color: '#F59E0B' },
  { name: 'Lake', emoji: '🏞️', description: 'Lakeside properties', icon: 'lake', color: '#06B6D4' },
  { name: 'Desert', emoji: '🏜️', description: 'Desert properties', icon: 'desert', color: '#EF4444' }
];

const sampleAmenities = [
  { name: 'Wi-Fi', icon: '📶', category: 'essential' },
  { name: 'Kitchen', icon: '🍳', category: 'essential' },
  { name: 'Free parking', icon: '🅿️', category: 'essential' },
  { name: 'Air conditioning', icon: '❄️', category: 'features' },
  { name: 'TV', icon: '📺', category: 'features' },
  { name: 'Balcony', icon: '🏞️', category: 'features' },
  { name: 'Pool', icon: '🏊', category: 'features' },
  { name: 'Gym', icon: '💪', category: 'features' },
  { name: 'Hot tub', icon: '♨️', category: 'features' },
  { name: 'Fireplace', icon: '🔥', category: 'features' },
  { name: 'Washer', icon: '🧺', category: 'features' },
  { name: 'Dryer', icon: '🌪️', category: 'features' },
  { name: 'Pet friendly', icon: '🐕', category: 'features' },
  { name: 'Smoking allowed', icon: '🚬', category: 'features' },
  { name: 'Wheelchair accessible', icon: '♿', category: 'accessibility' }
];

const sampleUsers = [
  {
    firstName: 'John',
    lastName: 'Doe',
    email: 'john.doe@example.com',
    password: 'password123',
    phone: '+1 (555) 123-4567',
    dateOfBirth: new Date('1990-05-15'),
    gender: 'male',
    isVerified: true,
    isHost: true
  },
  {
    firstName: 'Jane',
    lastName: 'Smith',
    email: 'jane.smith@example.com',
    password: 'password123',
    phone: '+1 (555) 234-5678',
    dateOfBirth: new Date('1988-08-22'),
    gender: 'female',
    isVerified: true,
    isHost: false
  },
  {
    firstName: 'Mike',
    lastName: 'Johnson',
    email: 'mike.johnson@example.com',
    password: 'password123',
    phone: '+1 (555) 345-6789',
    dateOfBirth: new Date('1992-12-10'),
    gender: 'male',
    isVerified: true,
    isHost: true
  },
  {
    firstName: 'Sarah',
    lastName: 'Wilson',
    email: 'sarah.wilson@example.com',
    password: 'password123',
    phone: '+1 (555) 456-7890',
    dateOfBirth: new Date('1985-03-18'),
    gender: 'female',
    isVerified: true,
    isHost: true
  },
  {
    firstName: 'David',
    lastName: 'Brown',
    email: 'david.brown@example.com',
    password: 'password123',
    phone: '+1 (555) 567-8901',
    dateOfBirth: new Date('1995-07-25'),
    gender: 'male',
    isVerified: false,
    isHost: false
  }
];

const sampleAdminUsers = [
  {
    firstName: 'Admin',
    lastName: 'User',
    email: 'admin@airbnbclone.com',
    password: 'admin123',
    phone: '+1 (555) 000-0001',
    role: 'super_admin',
    department: 'IT',
    permissions: ['all'],
    twoFactorEnabled: false
  },
  {
    firstName: 'Support',
    lastName: 'Staff',
    email: 'support@airbnbclone.com',
    password: 'support123',
    phone: '+1 (555) 000-0002',
    role: 'support',
    department: 'Customer Support',
    permissions: ['users:read', 'bookings:read', 'support_tickets:read', 'support_tickets:write'],
    twoFactorEnabled: false
  },
  {
    firstName: 'Moderator',
    lastName: 'User',
    email: 'moderator@airbnbclone.com',
    password: 'moderator123',
    phone: '+1 (555) 000-0003',
    role: 'moderator',
    department: 'Content',
    permissions: ['properties:read', 'properties:write', 'properties:verify', 'users:read'],
    twoFactorEnabled: false
  }
];

const seedDatabase = async () => {
  try {
    // Connect to database
    await connectDB();

    console.log('🗑️  Clearing database...');
    
    // Clear existing data
    await User.deleteMany({});
    await AdminUser.deleteMany({});
    await PropertyCategory.deleteMany({});
    await Amenity.deleteMany({});
    await Property.deleteMany({});
    await Booking.deleteMany({});
    await Payment.deleteMany({});
    await Review.deleteMany({});
    await SupportTicket.deleteMany({});

    console.log('✅ Database cleared');

    // Create categories
    console.log('📂 Creating property categories...');
    const categories = await PropertyCategory.insertMany(sampleCategories);
    console.log(`✅ Created ${categories.length} categories`);

    // Create amenities
    console.log('🏠 Creating amenities...');
    const amenities = await Amenity.insertMany(sampleAmenities);
    console.log(`✅ Created ${amenities.length} amenities`);

    // Create users
    console.log('👥 Creating users...');
    const users = await User.insertMany(sampleUsers);
    console.log(`✅ Created ${users.length} users`);

    // Create admin users
    console.log('👨‍💼 Creating admin users...');
    const adminUsers = await AdminUser.insertMany(sampleAdminUsers);
    console.log(`✅ Created ${adminUsers.length} admin users`);

    // Create properties
    console.log('🏘️  Creating properties...');
    const properties = [];
    
    for (let i = 0; i < 20; i++) {
      const host = users[Math.floor(Math.random() * users.filter(u => u.isHost).length)];
      const category = categories[Math.floor(Math.random() * categories.length)];
      const propertyAmenities = amenities.sort(() => 0.5 - Math.random()).slice(0, Math.floor(Math.random() * 8) + 3);
      
      const property = await Property.create({
        title: `Beautiful ${category.name} Property ${i + 1}`,
        description: `This is a wonderful ${category.name.toLowerCase()} property with amazing views and great amenities. Perfect for a relaxing getaway.`,
        location: {
          address: `${100 + i} Main Street`,
          city: ['New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix'][i % 5],
          state: ['NY', 'CA', 'IL', 'TX', 'AZ'][i % 5],
          country: 'United States',
          zipCode: `${10000 + i}`,
          coordinates: {
            latitude: 40.7128 + (Math.random() - 0.5) * 10,
            longitude: -74.0060 + (Math.random() - 0.5) * 10
          }
        },
        category: category._id,
        host: host._id,
        price: {
          basePrice: Math.floor(Math.random() * 300) + 50,
          currency: 'USD',
          cleaningFee: Math.floor(Math.random() * 50) + 25,
          serviceFee: Math.floor(Math.random() * 30) + 15,
          taxes: Math.floor(Math.random() * 20) + 10
        },
        capacity: {
          maxGuests: Math.floor(Math.random() * 8) + 2,
          bedrooms: Math.floor(Math.random() * 4) + 1,
          bathrooms: Math.floor(Math.random() * 3) + 1,
          beds: Math.floor(Math.random() * 5) + 1
        },
        amenities: propertyAmenities.map(a => a._id),
        images: [
          {
            url: `https://images.unsplash.com/photo-${1500000000000 + i}?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80`,
            caption: `Property ${i + 1} image`,
            isPrimary: true
          }
        ],
        ratings: {
          overall: Math.round((Math.random() * 2 + 3) * 10) / 10,
          cleanliness: Math.round((Math.random() * 2 + 3) * 10) / 10,
          accuracy: Math.round((Math.random() * 2 + 3) * 10) / 10,
          checkIn: Math.round((Math.random() * 2 + 3) * 10) / 10,
          communication: Math.round((Math.random() * 2 + 3) * 10) / 10,
          location: Math.round((Math.random() * 2 + 3) * 10) / 10,
          value: Math.round((Math.random() * 2 + 3) * 10) / 10
        },
        reviews: {
          totalCount: Math.floor(Math.random() * 50) + 5,
          averageRating: Math.round((Math.random() * 2 + 3) * 10) / 10
        },
        statistics: {
          totalBookings: Math.floor(Math.random() * 100),
          totalRevenue: Math.floor(Math.random() * 10000) + 1000,
          occupancyRate: Math.round((Math.random() * 40 + 30) * 10) / 10,
          viewCount: Math.floor(Math.random() * 1000) + 100,
          favoriteCount: Math.floor(Math.random() * 50) + 5
        },
        status: {
          isActive: Math.random() > 0.1,
          isVerified: Math.random() > 0.2,
          isBlocked: Math.random() > 0.95
        }
      });
      
      properties.push(property);
    }
    
    console.log(`✅ Created ${properties.length} properties`);

    // Create bookings
    console.log('📅 Creating bookings...');
    const bookings = [];
    
    for (let i = 0; i < 50; i++) {
      const user = users[Math.floor(Math.random() * users.length)];
      const property = properties[Math.floor(Math.random() * properties.length)];
      const checkIn = new Date();
      checkIn.setDate(checkIn.getDate() + Math.floor(Math.random() * 30) + 1);
      const checkOut = new Date(checkIn);
      checkOut.setDate(checkOut.getDate() + Math.floor(Math.random() * 7) + 1);
      
      const nights = Math.ceil((checkOut - checkIn) / (1000 * 60 * 60 * 24));
      const totalAmount = property.price.basePrice * nights + property.price.cleaningFee + property.price.serviceFee + property.price.taxes;
      
      const booking = await Booking.create({
        bookingNumber: `BK${Date.now()}${i}`,
        user: user._id,
        property: property._id,
        host: property.host,
        dates: {
          checkIn,
          checkOut,
          nights
        },
        guests: {
          adults: Math.floor(Math.random() * 4) + 1,
          children: Math.floor(Math.random() * 3),
          infants: Math.floor(Math.random() * 2),
          pets: Math.floor(Math.random() * 2)
        },
        pricing: {
          basePrice: property.price.basePrice * nights,
          cleaningFee: property.price.cleaningFee,
          serviceFee: property.price.serviceFee,
          taxes: property.price.taxes,
          totalAmount,
          currency: 'USD'
        },
        status: ['pending', 'confirmed', 'checked-in', 'checked-out', 'cancelled'][Math.floor(Math.random() * 5)],
        payment: {
          method: ['credit_card', 'paypal', 'stripe', 'apple_pay'][Math.floor(Math.random() * 4)],
          status: ['pending', 'completed', 'failed'][Math.floor(Math.random() * 3)],
          transactionId: `TXN_${Date.now()}${i}`
        }
      });
      
      bookings.push(booking);
    }
    
    console.log(`✅ Created ${bookings.length} bookings`);

    // Create payments
    console.log('💳 Creating payments...');
    const payments = [];
    
    for (let i = 0; i < 40; i++) {
      const booking = bookings[Math.floor(Math.random() * bookings.length)];
      const user = await User.findById(booking.user);
      const property = await Property.findById(booking.property);
      
      const payment = await Payment.create({
        paymentId: `PAY${Date.now()}${i}`,
        booking: booking._id,
        user: user._id,
        property: property._id,
        host: property.host,
        amount: {
          total: booking.pricing.totalAmount,
          baseAmount: booking.pricing.basePrice,
          platformFee: booking.pricing.serviceFee * 0.1,
          hostAmount: booking.pricing.totalAmount * 0.85,
          taxAmount: booking.pricing.taxes,
          currency: 'USD'
        },
        method: {
          type: booking.payment.method
        },
        status: booking.payment.status,
        transaction: {
          stripePaymentIntentId: `pi_${Date.now()}${i}`,
          transactionFee: booking.pricing.totalAmount * 0.029 + 0.30,
          netAmount: booking.pricing.totalAmount * 0.971 - 0.30
        },
        timeline: {
          initiatedAt: new Date(Date.now() - Math.floor(Math.random() * 30) * 24 * 60 * 60 * 1000),
          processedAt: new Date(Date.now() - Math.floor(Math.random() * 29) * 24 * 60 * 60 * 1000),
          completedAt: new Date(Date.now() - Math.floor(Math.random() * 28) * 24 * 60 * 60 * 1000)
        }
      });
      
      payments.push(payment);
    }
    
    console.log(`✅ Created ${payments.length} payments`);

    // Create reviews
    console.log('⭐ Creating reviews...');
    const reviews = [];
    
    for (let i = 0; i < 100; i++) {
      const booking = bookings[Math.floor(Math.random() * bookings.length)];
      const user = await User.findById(booking.user);
      const property = await Property.findById(booking.property);
      
      if (booking.status === 'checked-out') {
        const review = await Review.create({
          property: property._id,
          booking: booking._id,
          guest: user._id,
          host: property.host,
          ratings: {
            overall: Math.round((Math.random() * 2 + 3) * 10) / 10,
            cleanliness: Math.round((Math.random() * 2 + 3) * 10) / 10,
            accuracy: Math.round((Math.random() * 2 + 3) * 10) / 10,
            checkIn: Math.round((Math.random() * 2 + 3) * 10) / 10,
            communication: Math.round((Math.random() * 2 + 3) * 10) / 10,
            location: Math.round((Math.random() * 2 + 3) * 10) / 10,
            value: Math.round((Math.random() * 2 + 3) * 10) / 10
          },
          comment: `Great property! Had an amazing time. The location was perfect and the host was very responsive. Would definitely stay here again!`,
          isPublic: true,
          isVerified: true,
          status: 'approved'
        });
        
        reviews.push(review);
      }
    }
    
    console.log(`✅ Created ${reviews.length} reviews`);

    // Create support tickets
    console.log('🎫 Creating support tickets...');
    const supportTickets = [];
    
    for (let i = 0; i < 20; i++) {
      const user = users[Math.floor(Math.random() * users.length)];
      const booking = Math.random() > 0.5 ? bookings[Math.floor(Math.random() * bookings.length)] : null;
      
      const ticket = await SupportTicket.create({
        ticketNumber: `TKT${Date.now()}${i}`,
        user: user._id,
        subject: `Support Request ${i + 1}`,
        category: ['technical', 'billing', 'account', 'booking', 'general'][Math.floor(Math.random() * 5)],
        priority: ['low', 'medium', 'high'][Math.floor(Math.random() * 3)],
        status: ['open', 'in_progress', 'resolved', 'closed'][Math.floor(Math.random() * 4)],
        description: `I need help with ${['my booking', 'payment issue', 'account settings', 'technical problem', 'general inquiry'][Math.floor(Math.random() * 5)]}. Please assist me with resolving this matter.`,
        messages: [
          {
            sender: 'user',
            senderId: user._id,
            message: `I need help with ${['my booking', 'payment issue', 'account settings', 'technical problem', 'general inquiry'][Math.floor(Math.random() * 5)]}.`,
            timestamp: new Date(Date.now() - Math.floor(Math.random() * 7) * 24 * 60 * 60 * 1000)
          }
        ],
        assignedTo: Math.random() > 0.3 ? adminUsers[Math.floor(Math.random() * adminUsers.length)]._id : undefined,
        relatedBooking: booking ? booking._id : undefined,
        timeline: {
          openedAt: new Date(Date.now() - Math.floor(Math.random() * 7) * 24 * 60 * 60 * 1000),
          lastActivityAt: new Date(Date.now() - Math.floor(Math.random() * 3) * 24 * 60 * 60 * 1000)
        }
      });
      
      supportTickets.push(ticket);
    }
    
    console.log(`✅ Created ${supportTickets.length} support tickets`);

    console.log('🎉 Database seeding completed successfully!');
    console.log('\n📊 Summary:');
    console.log(`   Users: ${users.length}`);
    console.log(`   Admin Users: ${adminUsers.length}`);
    console.log(`   Categories: ${categories.length}`);
    console.log(`   Amenities: ${amenities.length}`);
    console.log(`   Properties: ${properties.length}`);
    console.log(`   Bookings: ${bookings.length}`);
    console.log(`   Payments: ${payments.length}`);
    console.log(`   Reviews: ${reviews.length}`);
    console.log(`   Support Tickets: ${supportTickets.length}`);
    
    console.log('\n🔑 Test Accounts:');
    console.log('   Admin: admin@airbnbclone.com / admin123');
    console.log('   Support: support@airbnbclone.com / support123');
    console.log('   Moderator: moderator@airbnbclone.com / moderator123');
    console.log('   User: john.doe@example.com / password123');

    process.exit(0);
  } catch (error) {
    console.error('❌ Error seeding database:', error);
    process.exit(1);
  }
};

// Run seeder if called directly
if (require.main === module) {
  seedDatabase();
}

module.exports = seedDatabase;
