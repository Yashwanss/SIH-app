# SafeTravel - Complete Design Specification

## 📱 App Overview
A modern tourism safety application designed for northeastern states of India with three main screens, multilingual support for 8 regional languages, and comprehensive emergency features.

## 🎨 Design System

### Color Palette

#### Primary Colors
- **Background**: `#ffffff` (White)
- **Foreground**: `oklch(0.145 0 0)` (Near Black)
- **Primary**: `#030213` (Deep Dark Blue)
- **Primary Foreground**: `oklch(1 0 0)` (Pure White)

#### Secondary Colors
- **Secondary**: `oklch(0.95 0.0058 264.53)` (Light Blue Gray)
- **Secondary Foreground**: `#030213` (Deep Dark Blue)
- **Muted**: `#ececf0` (Light Gray)
- **Muted Foreground**: `#717182` (Medium Gray)

#### Interactive Colors
- **Accent**: `#e9ebef` (Light Blue Gray)
- **Accent Foreground**: `#030213` (Deep Dark Blue)
- **Destructive**: `#d4183d` (Red)
- **Destructive Foreground**: `#ffffff` (White)

#### Emergency Colors
- **Emergency Red**: `#dc2626` (Red-600)
- **Emergency Red Hover**: `#b91c1c` (Red-700)
- **Police Blue**: `#2563eb` (Blue-600)
- **Ambulance Red**: `#dc2626` (Red-600)
- **Fire Orange**: `#ea580c` (Orange-600)
- **Women Safety Purple**: `#9333ea` (Purple-600)
- **Tourist Green**: `#16a34a` (Green-600)

#### Status Colors
- **Success Green**: `#16a34a` (Green-600)
- **Warning Yellow**: `#ca8a04` (Yellow-600)
- **Info Blue**: `#2563eb` (Blue-600)

#### Border & Input
- **Border**: `rgba(0, 0, 0, 0.1)` (10% Black)
- **Input Background**: `#f3f3f5` (Light Gray)
- **Switch Background**: `#cbced4` (Gray)

### Typography

#### Font Sizes
- **Base Font Size**: `16px`
- **H1**: `24px` (1.5rem)
- **H2**: `20px` (1.25rem)
- **H3**: `18px` (1.125rem)
- **H4**: `16px` (1rem)
- **Body**: `16px` (1rem)
- **Small**: `14px` (0.875rem)
- **Extra Small**: `12px` (0.75rem)

#### Font Weights
- **Normal**: `400`
- **Medium**: `500`
- **Semibold**: `600`
- **Bold**: `700`

#### Line Height
- **All Text Elements**: `1.5` (150%)

### Spacing & Layout

#### Border Radius
- **Small**: `6px` (0.375rem)
- **Medium**: `8px` (0.5rem)
- **Large**: `10px` (0.625rem)
- **Extra Large**: `14px` (0.875rem)
- **Full**: `9999px` (Circular)

#### Spacing Scale
- **1**: `4px` (0.25rem)
- **2**: `8px` (0.5rem)
- **3**: `12px` (0.75rem)
- **4**: `16px` (1rem)
- **5**: `20px` (1.25rem)
- **6**: `24px` (1.5rem)
- **8**: `32px` (2rem)
- **12**: `48px` (3rem)
- **16**: `64px` (4rem)
- **20**: `80px` (5rem)

#### Grid & Layout
- **Mobile Screen Width**: `375px` (iPhone SE) to `428px` (iPhone 14 Pro Max)
- **Content Padding**: `16px` (1rem)
- **Header Height**: `64px` (4rem)
- **Bottom Navigation Height**: `84px` (5.25rem)
- **Map Section Height**: `288px` (18rem)

## 🖼️ Screen Specifications

### App Structure
```
Total Height: 100vh (Mobile viewport)
├── Header: 64px
├── Weather Alert: 56px (Home screen only)
├── Main Content: Flex-1 (Remaining space)
└── Bottom Navigation: 84px
```

### Header Component
- **Height**: `64px`
- **Background**: `#ffffff`
- **Border Bottom**: `1px solid rgba(0, 0, 0, 0.1)`
- **Padding**: `12px 16px`
- **Shadow**: `0 1px 3px rgba(0, 0, 0, 0.1)`

#### Header Elements
- **Title**: H1, 18px, font-weight: 700, color: `#1f2937`
- **Menu Button**: 40px × 40px, ghost style, icon: 20px

### Bottom Navigation
- **Height**: `84px`
- **Background**: `#ffffff`
- **Border Top**: `1px solid rgba(0, 0, 0, 0.1)`
- **Shadow**: `0 -4px 6px rgba(0, 0, 0, 0.1)`
- **Padding**: `4px 8px`

#### Navigation Items
- **Container**: Flex, 3 items, equal width
- **Button Height**: `64px`
- **Icon Size**: `24px`
- **Text Size**: `12px`
- **Gap Between Icon & Text**: `4px`

#### Navigation States
- **Active State**: Primary background color
- **Emergency Active**: Red-600 background with white text
- **Inactive State**: Ghost style with appropriate text colors

## 📱 Screen Details

### 1. Home Screen

#### Map Section
- **Height**: `288px` (18rem)
- **Background**: `#dcfce7` (Green-100)
- **Border Bottom**: `2px solid #16a34a` (Green-500)

##### User Location Indicator
- **Container**: White circle, `64px` diameter, centered
- **Shadow**: `0 4px 6px rgba(0, 0, 0, 0.1)`
- **Icon**: MapPin, `32px`, color: `#dc2626` (Red-500)
- **Pulse Indicator**: `16px` circle, top-right corner, blue-500, animated

##### Offline Badge
- **Position**: Absolute, top-right (12px from edges)
- **Background**: `#16a34a` (Green-600)
- **Text**: White, 12px
- **Icon**: WiFiOff, 12px
- **Padding**: `4px 8px`
- **Border Radius**: `4px`

##### Location Info Card
- **Background**: White
- **Padding**: `8px 16px`
- **Border Radius**: `8px`
- **Shadow**: `0 2px 4px rgba(0, 0, 0, 0.1)`
- **Text**: 14px gray-600, 16px medium for location name

#### Points of Interest Section
- **Header**: Navigation icon (20px) + "Nearby POIs" text (18px, semibold)
- **Margin Bottom**: `16px`

##### POI Cards
- **Background**: White
- **Border Radius**: `8px`
- **Shadow**: `0 1px 3px rgba(0, 0, 0, 0.1)`
- **Padding**: `16px`
- **Margin Bottom**: `12px`

##### POI Card Layout
```
[Icon Container] [Content] [Action Button]
     64px         Flex-1        80px
```

- **Icon Container**: `32px` square, background: `#dbeafe` (Blue-100), border-radius: `8px`
- **Icon**: `16px`, color: blue-600
- **Title**: 16px, medium weight
- **Subtitle**: 14px, gray-600, distance • rating format
- **Action Button**: "Get Directions" with Navigation icon (12px)

### 2. Emergency Screen

#### SOS Section
- **Background**: Linear gradient from `#dc2626` to `#b91c1c` (Red-500 to Red-600)
- **Text Color**: White
- **Padding**: `16px`

##### SOS Button
- **Size**: `144px` diameter (w-36 h-36)
- **Border Radius**: `9999px` (Full circle)
- **Font Size**: `24px` (text-2xl)
- **Font Weight**: `700` (bold)
- **Shadow**: `0 10px 15px rgba(0, 0, 0, 0.1)`

###### SOS Button States
- **Normal**: Background: `#991b1b` (Red-700), text: white
- **Pressed**: Background: white, text: `#dc2626` (Red-600), with pulse animation
- **Content**: "SOS" text or "🚨" emoji when activated

##### Location Share Button
- **Background**: `rgba(255, 255, 255, 0.2)` (White 20% opacity)
- **Border**: `1px solid rgba(255, 255, 255, 0.3)`
- **Text**: White
- **Icon**: Share2, 16px
- **Padding**: `8px 16px`
- **Border Radius**: `6px`

#### Emergency Services Grid
- **Layout**: 2 columns, 3px gap
- **Button Height**: `96px` (h-24)
- **Border Radius**: `12px` (rounded-xl)
- **Shadow**: `0 4px 6px rgba(0, 0, 0, 0.1)`

##### Service Button Colors
- **Police**: `#2563eb` (Blue-600)
- **Ambulance**: `#dc2626` (Red-600)
- **Fire**: `#ea580c` (Orange-600)
- **Women**: `#9333ea` (Purple-600)
- **Tourist**: `#16a34a` (Green-600)

##### Service Button Layout
```
   Icon (24px)
Service Name (14px, medium)
Number (12px, 90% opacity)
```

#### Local Contacts Card
- **Card Header**: Phone icon (16px) + "Local Emergency Contacts" (16px, medium)
- **Contact Item**: Background: `#f9fafb` (Gray-50), padding: `8px`, border-radius: `8px`
- **Call Button**: Outline style, Phone icon (12px) + "Call" text

### 3. Profile Screen

#### Profile Card
- **Padding**: `24px`
- **Background**: White
- **Border Radius**: `8px`
- **Shadow**: `0 1px 3px rgba(0, 0, 0, 0.1)`

##### Avatar & Info Layout
```
[Avatar] [User Info] [Edit Button]
  64px     Flex-1        80px
```

- **Avatar**: `64px` circle, background: `#dbeafe` (Blue-100), initials: blue-600
- **Name**: 18px, semibold
- **Location**: 14px, gray-600, with MapPin icon (12px)
- **Contact Info**: 14px, with Mail/Phone icons (16px, gray-500)

#### Settings Sections
Each settings card follows this pattern:
- **Card Header**: Icon (16px) + Title (16px, medium)
- **Card Padding**: `24px` header, `16px` content

##### Language Selector
- **Select Width**: `128px`
- **Options**: 8 languages with native scripts

##### Safety Settings
- **Toggle Item Layout**: Label (14px) + Badge + Switch
- **Badge Colors**: Green-100/green-700 for enabled, secondary for disabled
- **Switch**: Default ShadCN styling

##### Women's Safety Section
- **Border**: Purple-200
- **Title Color**: Purple-700
- **Toggle Backgrounds**: Purple-50
- **Padding**: `12px` for toggle items

## 🔄 Interactions & States

### Button States
1. **Default**: Base colors as specified
2. **Hover**: 10% darker shade of background
3. **Active/Pressed**: Visual feedback with scale or color change
4. **Disabled**: 50% opacity, no pointer events

### Emergency Button Special States
- **SOS Pressed**: White background, red text, pulse animation for 5 seconds
- **Location Shared**: Green alert notification for 3 seconds

### Loading States
- **Weather Data**: Skeleton loading in weather card
- **Maps**: Grid overlay with loading indicator
- **Emergency Calls**: Brief "Calling..." modal

## 🌍 Multilingual Support

### Supported Languages
1. **English** (en)
2. **Assamese** (as) - অসমীয়া
3. **Hindi** (hi) - हिन्दी
4. **Bengali** (bn) - বাংলা
5. **Telugu** (te) - తెలుగు
6. **Tamil** (ta) - தமிழ்
7. **Marathi** (mr) - मराठी
8. **Gujarati** (gu) - ગુજરાતી

### Text Handling
- **Dynamic Text**: All UI text changes based on selected language
- **Fallback**: English as default if translation missing
- **Font Support**: System fonts with proper Unicode support for all scripts

## 📏 Component Specifications

### Cards
- **Background**: White
- **Border Radius**: `8px`
- **Shadow**: `0 1px 3px rgba(0, 0, 0, 0.1)`
- **Border**: `1px solid rgba(0, 0, 0, 0.1)`

### Buttons
- **Height**: Minimum `44px` for touch targets
- **Border Radius**: `6px`
- **Font Weight**: `500` (medium)
- **Padding**: `8px 16px` for regular, `6px 12px` for small

### Form Elements
- **Input Height**: `40px`
- **Background**: `#f3f3f5`
- **Border**: `1px solid rgba(0, 0, 0, 0.1)`
- **Border Radius**: `6px`
- **Focus State**: Ring shadow with primary color

### Icons
- **Standard Size**: `16px` for inline, `20px` for buttons, `24px` for navigation
- **Emergency Icons**: `24px` in service buttons
- **Map Icons**: `32px` for location marker

## 📱 Mobile Optimization

### Touch Targets
- **Minimum Size**: `44px × 44px`
- **Bottom Navigation Items**: `64px` height
- **Emergency Buttons**: Large touch areas for stress situations

### Safe Areas
- **Bottom Padding**: `env(safe-area-inset-bottom)` for devices with home indicator
- **Scroll Behavior**: Hidden scrollbars on mobile, momentum scrolling

### Performance
- **React.memo**: All major components memoized
- **useCallback**: Event handlers optimized
- **Centralized Translations**: Efficient language switching

## 🚨 Emergency Features

### SOS Functionality
- **Activation**: Large, accessible button in center
- **Visual Feedback**: Color inversion and pulse animation
- **Auto-Reset**: 5-second timeout

### Quick Actions
- **One-Touch Calling**: Direct dial to emergency services
- **Location Sharing**: GPS coordinates to contacts
- **Panic Alerts**: Women's safety features

### Accessibility
- **High Contrast**: Emergency elements clearly visible
- **Large Touch Targets**: Easy to use under stress
- **Clear Hierarchy**: Important actions prioritized

## 📐 Figma Recreation Steps

### 1. Setup Design System
1. Create color styles for all color tokens
2. Set up text styles for typography
3. Create component library for buttons, cards, icons
4. Define spacing and layout grids

### 2. Create Screen Templates
1. Mobile frame (375px × 812px)
2. Header component (64px height)
3. Bottom navigation component (84px height)
4. Content area calculations

### 3. Build Components
1. Navigation bars (top and bottom)
2. Cards (POI, weather, settings)
3. Buttons (all variants and states)
4. Emergency service grid
5. Form elements

### 4. Create Screen Flows
1. Home screen with map and POI list
2. Emergency screen with SOS and services
3. Profile screen with settings
4. Modal states and overlays

### 5. Add Interactions
1. Component state variants
2. Button hover/pressed states
3. Navigation transitions
4. Emergency button animations

---

*This specification document contains all the design tokens, measurements, colors, and layout information needed to recreate the tourism safety app in Figma. Each component includes exact specifications for spacing, colors, typography, and interactive states.*