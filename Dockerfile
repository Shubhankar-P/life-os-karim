# Life OS Dockerfile
FROM oven/bun:1 AS base

# Install dependencies
WORKDIR /app
COPY package.json bun.lock ./
RUN bun install --frozen-lockfile

# Copy source
COPY . .

# Set environment
ENV NODE_ENV=production
# Placeholder only, so `prisma generate` can resolve the schema at build time.
# The real DATABASE_URL is supplied at runtime (see docker-compose.yml).
ENV DATABASE_URL="postgresql://postgres:postgres@localhost:5432/life_os"

# Generate Prisma client
RUN bun run db:generate

# Build the Next.js app
RUN bun run build

# Expose port
EXPOSE 3000

# Start
CMD ["sh", "-c", "bun run db:push && bun run start"]
