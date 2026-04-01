import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardFooter, CardHeader } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Check } from "lucide-react";

interface PricingCardProps {
  name: string;
  price: number;
  originalPrice?: number | null;
  period: string;
  description: string;
  features: readonly string[];
  cta: string;
  popular: boolean;
  type: string;
}

export default function PricingCard({
  name,
  price,
  originalPrice,
  period,
  description,
  features,
  cta,
  popular,
  type,
}: PricingCardProps) {
  const href = type === "free" ? "/register" : `/payment/${type}`;
  return (
    <Card
      className={`relative flex flex-col overflow-visible ${
        popular ? "border-brand shadow-lg scale-105 mt-4" : ""
      }`}
    >
      {popular && (
        <Badge className="absolute -top-3 left-1/2 -translate-x-1/2 bg-brand text-white px-4 z-10">
          แนะนำ
        </Badge>
      )}
      <CardHeader className="text-center pb-2">
        <h3 className="text-lg font-bold">{name}</h3>
        <p className="text-sm text-muted-foreground">{description}</p>
      </CardHeader>
      <CardContent className="text-center flex-1">
        <div className="my-4">
          {originalPrice != null && originalPrice > price && (
            <p className="text-sm text-muted-foreground line-through mb-0.5">
              ฿{originalPrice.toLocaleString()}
            </p>
          )}
          <div className="flex items-center justify-center gap-2">
            <span className="text-4xl font-bold">
              {price === 0 ? "ฟรี" : `฿${price.toLocaleString()}`}
            </span>
            {originalPrice != null && originalPrice > price && price > 0 && (
              <Badge className="bg-red-100 text-red-600 text-xs font-semibold">
                -{Math.round((1 - price / originalPrice) * 100)}%
              </Badge>
            )}
          </div>
          {period && (
            <span className="text-muted-foreground text-sm"> {period}</span>
          )}
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
      <CardFooter>
        <Link href={href} className="w-full">
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
      </CardFooter>
    </Card>
  );
}
