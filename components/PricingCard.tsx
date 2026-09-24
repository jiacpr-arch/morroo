"use client";

import Link from "next/link";
import { track } from "@/lib/analytics";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardFooter, CardHeader } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Check } from "lucide-react";

interface PricingCardProps {
  name: string;
  price: number;
  period: string;
  description: string;
  features: readonly string[];
  cta: string;
  popular: boolean;
  type: string;
  /** Optional yearly SKU for per-product plans — rendered as a secondary link. */
  yearlyType?: string;
  /** Regular price shown struck through next to a first-purchase `price`. */
  compareAt?: number | null;
  /** Small line under the price, e.g. what the next purchase costs. */
  note?: string;
  /** Top badge text; defaults to "แนะนำ" on `popular` cards. */
  badge?: string;
}

export default function PricingCard({
  name,
  price,
  period,
  description,
  features,
  cta,
  popular,
  type,
  yearlyType,
  compareAt,
  note,
  badge,
}: PricingCardProps) {
  const href = type === "free" ? "/register" : `/payment/${type}`;
  const badgeText = badge ?? (popular ? "แนะนำ" : null);
  const savePercent = compareAt && compareAt > price ? Math.round((1 - price / compareAt) * 100) : 0;
  return (
    <Card
      className={`relative flex flex-col overflow-visible ${
        popular ? "ring-2 ring-brand shadow-xl shadow-brand/10" : ""
      }`}
    >
      {badgeText && (
        <Badge
          className={`absolute -top-3 left-1/2 -translate-x-1/2 px-4 z-10 text-white ${
            popular ? "bg-brand" : "bg-amber-500"
          }`}
        >
          {badgeText}
        </Badge>
      )}
      <CardHeader className="text-center pb-2">
        <h3 className="text-lg font-bold">{name}</h3>
        <p className="text-sm text-muted-foreground">{description}</p>
      </CardHeader>
      <CardContent className="text-center flex-1">
        <div className="my-4">
          {savePercent > 0 && (
            <div className="mb-1 flex items-center justify-center gap-2 text-sm">
              <span className="text-muted-foreground line-through">
                ฿{compareAt!.toLocaleString()}
              </span>
              <span className="rounded-full bg-red-50 px-2 py-0.5 text-xs font-semibold text-red-600">
                ลด {savePercent}%
              </span>
            </div>
          )}
          <span className="text-4xl font-bold">
            {price === 0 ? "ฟรี" : `฿${price.toLocaleString()}`}
          </span>
          {period && (
            <span className="text-muted-foreground text-sm"> {period}</span>
          )}
          {note && <p className="mt-1 text-xs text-muted-foreground">{note}</p>}
        </div>
        <ul className="space-y-2 text-sm text-left">
          {features.map((feature) => (
            <li key={feature} className="flex items-start gap-2">
              <Check className="h-4 w-4 text-brand mt-0.5 shrink-0" />
              <span>{feature}</span>
            </li>
          ))}
        </ul>
      </CardContent>
      <CardFooter className="flex-col gap-2">
        <Link
          href={href}
          className="w-full"
          onClick={() => track("plan_selected", { plan: type, price })}
        >
          <Button
            className={`w-full ${
              popular
                ? "bg-brand hover:bg-brand-light text-white"
                : "bg-brand-dark hover:bg-brand-dark/90 text-white"
            }`}
          >
            {cta}
          </Button>
        </Link>
        {yearlyType && (
          <Link
            href={`/payment/${yearlyType}`}
            className="text-xs text-muted-foreground underline-offset-2 hover:underline hover:text-brand"
            onClick={() => track("plan_selected", { plan: yearlyType, price })}
          >
            สมัครรายปีแทน
          </Link>
        )}
      </CardFooter>
    </Card>
  );
}
