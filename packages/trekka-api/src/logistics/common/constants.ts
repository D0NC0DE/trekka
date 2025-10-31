import { VehicleClass } from "./enum";

// All Fees in HBAR... We willl update to fiat and other tokens later
export const BASE_FARE = 3;
export const PER_KILOMETER_RATE = 1;
export const PER_MINUTE_RATE = 0.2;
export const SURGE_MIN = 1.0;
export const SURGE_MAX = 2.0;

export const VEHICLE_CLASS_MULTIPLIERS: Record<VehicleClass, number> = {
  [VehicleClass.NO_AC]: 0.6,
  [VehicleClass.NORMAL]: 1.0,
  [VehicleClass.PREMIUM]: 1.5,
  [VehicleClass.VVIP]: 2.0,
};

export const MIN_FARE = 3.5;
export const PRIORITY_FEE = 3;
export const SERVICE_FEE_RATE = 0.05;
export const SERVICE_FEE_MIN = 0.5;
export const SERVICE_FEE_MAX = 4;
export const ROUNDING_INTERVAL = 0.1;

export const DEFAULT_CURRENCY = 'HBAR';
